`timescale 1ns/1ps
// Mô phỏng top FPGA (RTL hoặc netlist sau tổng hợp): giải mã UART 115200 @ 27 MHz, báo trap
module tb_fpga;
    reg clk = 0;
    always #18.519 clk = ~clk;                  // 27 MHz
    wire tx, led0;
    wire [2:0] dbg;
    tangnano20k_top dut(.clk(clk), .btn_s1(1'b0), .uart_tx(tx), .led0(led0), .dbg_led(dbg));

    reg [7:0] c; integer i;
    initial forever begin                       // 8N1, 234 chu kỳ/bit
        @(negedge tx);
        repeat (117) @(posedge clk);
        for (i = 0; i < 8; i = i + 1) begin repeat (234) @(posedge clk); c[i] = tx; end
        repeat (234) @(posedge clk);
        if (c == 8'd4) begin $display("\n[tb] EOT - chay het chuong trinh"); $finish; end
        $write("%c", c);
    end

    integer n = 0;
    always @(posedge clk) begin
        n <= n + 1;
        if (n > 50 && dbg[0] === 1'b0) begin $display("\n[tb] TRAP o chu ky %0d", n); $finish; end
        if (n == 60000) begin $display("\n[tb] het 60000 chu ky, khong trap"); $finish; end
    end
endmodule
