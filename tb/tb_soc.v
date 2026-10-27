`timescale 1ns/1ps
module tb_soc;
    reg clk = 0;
    reg rst = 1;
    always #10 clk = ~clk;                       // 50 MHz

    localparam CLK_DIV = 16;                     // UART nhanh để mô phỏng ngắn

    wire uart_tx, trap;

    soc_top #(.RAM_WORDS(1024), .CLK_DIV(CLK_DIV), .FW_HEX("sw/fw.hex")) dut (
        .clk(clk), .rst(rst), .uart_tx(uart_tx), .trap(trap)
    );

    // Chuỗi mong đợi (33 ký tự), firmware kết thúc bằng byte 0x04 (EOT)
    localparam NEXP = 33;
    localparam [8*NEXP-1:0] EXPECT = "Hello, RISC-V SoC!\nDMA OK\nIRQ OK\n";
    integer n = 0;
    integer bad = 0;
    integer i;
    reg [7:0] ch;

    // Đo thời gian BUSY của DMA (chu kỳ clk), giữ giá trị của lần chép gần nhất
    integer cyc = 0, busy_t0 = 0, busy_cycles = 0;
    always @(posedge clk) cyc <= cyc + 1;
    always @(posedge dut.core.dma.busy) busy_t0 = cyc;
    always @(negedge dut.core.dma.busy) if (!rst) busy_cycles = cyc - busy_t0;

    // Giải mã UART 8N1 rồi in ký tự ra console
    initial begin
        forever begin
            @(negedge uart_tx);                              // bit start
            repeat (CLK_DIV + CLK_DIV/2) @(posedge clk);     // giữa bit d0
            for (i = 0; i < 8; i = i + 1) begin
                ch[i] = uart_tx;
                repeat (CLK_DIV) @(posedge clk);
            end
            if (ch == 8'h04) begin
                if (n >= NEXP && bad == 0) $display("PASS: SoC va DMA hoat dong dung");
                else                       $display("FAIL: nhan %0d ky tu, %0d ky tu sai", n, bad);
                $display("DMA busy (lan chep cuoi): %0d chu ky", busy_cycles);
                $finish;
            end else begin
                $write("%c", ch);
                if (n < NEXP && ch !== EXPECT[8*(NEXP-1-n) +: 8]) bad = bad + 1;
                n = n + 1;
            end
        end
    end

    always @(posedge clk) if (trap) begin
        $display("FAIL: CPU bao trap");
        $finish;
    end

    initial begin
        $dumpfile("soc.vcd");
        $dumpvars(0, tb_soc);
        repeat (8) @(posedge clk);
        #1 rst = 0;
    end

    initial begin
        #20_000_000;
        $display("FAIL: watchdog het thoi gian");
        $finish;
    end
endmodule
