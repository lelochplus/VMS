`timescale 1ns/1ps
module tb_dma;
    reg clk = 0;
    reg rst = 1;
    always #10 clk = ~clk;                 // 50 MHz

    // Cong slave: CPU -> DMA
    reg         s_cyc = 0, s_stb = 0, s_we = 0;
    reg  [4:2]  s_adr = 0;
    reg  [31:0] s_dat_i = 0;
    wire [31:0] s_dat_o;
    wire        s_ack;

    // Cong master: DMA -> bo nho
    wire        m_cyc, m_stb, m_we;
    wire [31:0] m_adr, m_dat_o;
    wire [3:0]  m_sel;
    reg  [31:0] m_dat_i = 0;
    reg         m_ack = 0, m_err = 0;
    wire        irq;

    dma_ctrl dut (
        .clk(clk), .rst(rst),
        .s_cyc(s_cyc), .s_stb(s_stb), .s_we(s_we), .s_adr(s_adr),
        .s_dat_i(s_dat_i), .s_dat_o(s_dat_o), .s_ack(s_ack),
        .m_cyc(m_cyc), .m_stb(m_stb), .m_we(m_we),
        .m_adr(m_adr), .m_dat_o(m_dat_o), .m_sel(m_sel),
        .m_dat_i(m_dat_i), .m_ack(m_ack), .m_err(m_err),
        .irq(irq)
    );

    localparam [4:2] R_CTRL = 3'd0, R_STATUS = 3'd1, R_SRC = 3'd2,
                     R_DST  = 3'd3, R_LEN    = 3'd4;
    localparam [31:0] ST_BUSY = 32'd1, ST_DONE = 32'd2, ST_ERR = 32'd4;

    // ---------------- Bo nho gia (slave) ----------------
    reg [31:0] mem [0:255];            // chi so word = dia chi[9:2]
    integer    max_lat = 0;            // do tre ngau nhien 0..max_lat chu ky
    reg        err_en = 0;
    reg [31:0] err_addr = 0;
    integer    wait_cnt = 0;
    reg        pending = 0;

    always @(posedge clk) begin
        m_ack <= 0;
        m_err <= 0;
        if (m_cyc && m_stb && !m_ack && !m_err) begin
            if (!pending) begin
                pending  <= 1;
                wait_cnt <= $urandom_range(max_lat, 0);
            end else if (wait_cnt == 0) begin
                pending <= 0;
                if (err_en && m_adr == err_addr) begin
                    m_err <= 1;
                end else begin
                    m_ack <= 1;
                    if (m_we) mem[m_adr[9:2]] <= m_dat_o;
                    else      m_dat_i <= mem[m_adr[9:2]];
                end
            end else begin
                wait_cnt <= wait_cnt - 1;
            end
        end
    end

    // ---------------- Cong cu kiem tra ----------------
    integer errors = 0;
    integer seed   = 0;
    reg [31:0] r;
    reg [31:0] last_st;

    task expect_eq(input [8*32-1:0] name, input [31:0] got, input [31:0] exp);
    begin
        if (got !== exp) begin
            errors = errors + 1;
            $display("FAIL %0s: got=%h exp=%h", name, got, exp);
        end
    end
    endtask

    task check_copy(input [8*32-1:0] name, input integer si, input integer di, input integer n);
        integer i;
    begin
        for (i = 0; i < n; i = i + 1)
            if (mem[di + i] !== mem[si + i]) begin
                errors = errors + 1;
                $display("FAIL %0s: word %0d got=%h exp=%h", name, i, mem[di + i], mem[si + i]);
            end
    end
    endtask

    task init_mem;
        integer i;
    begin
        seed = seed + 1;
        for (i = 0; i < 128; i = i + 1) mem[i] <= {seed[7:0], 8'hA5, 8'h00, i[7:0]};
        for (i = 128; i < 256; i = i + 1) mem[i] <= 32'h0;
        @(posedge clk); #1;
    end
    endtask

    // ---------------- Mo hinh CPU (Wishbone master) ----------------
    task cfg_write(input [4:2] a, input [31:0] d);
    begin
        s_cyc = 1; s_stb = 1; s_we = 1; s_adr = a; s_dat_i = d;
        @(posedge clk); #1;
        while (!s_ack) begin @(posedge clk); #1; end
        s_cyc = 0; s_stb = 0; s_we = 0;
        @(posedge clk); #1;
    end
    endtask

    task cfg_read(input [4:2] a, output [31:0] d);
    begin
        s_cyc = 1; s_stb = 1; s_we = 0; s_adr = a;
        @(posedge clk); #1;
        while (!s_ack) begin @(posedge clk); #1; end
        d = s_dat_o;
        s_cyc = 0; s_stb = 0;
        @(posedge clk); #1;
    end
    endtask

    task wait_idle;
        integer timeout;
    begin
        timeout = 0;
        last_st = ST_BUSY;
        while (last_st[0] && timeout < 20000) begin
            cfg_read(R_STATUS, last_st);
            timeout = timeout + 1;
        end
        if (timeout >= 20000) begin
            errors = errors + 1;
            $display("FAIL: het thoi gian cho DMA");
        end
    end
    endtask

    task run_dma(input [31:0] src, input [31:0] dst, input [31:0] words,
                 input sinc, input dinc, input use_irq);
    begin
        cfg_write(R_SRC, src);
        cfg_write(R_DST, dst);
        cfg_write(R_LEN, words);
        cfg_write(R_CTRL, {28'd0, dinc, sinc, use_irq, 1'b1});   // bit0 = START
        wait_idle;
    end
    endtask

    task clear_status;
    begin
        cfg_write(R_STATUS, 32'h6);      // xoa DONE va ERR
    end
    endtask

    // ---------------- Cac ca kiem tra ----------------
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_dma);
        repeat (4) @(posedge clk);
        #1 rst = 0;
        @(posedge clk); #1;

        $display("T1: copy 8 word, tre 0..3 chu ky");
        max_lat = 3; init_mem;
        run_dma(32'h000, 32'h200, 8, 1, 1, 0);
        expect_eq("T1 status", last_st, ST_DONE);
        check_copy("T1 du lieu", 0, 128, 8);
        expect_eq("T1 irq (IRQ_EN=0)", {31'd0, irq}, 0);
        cfg_read(R_SRC, r); expect_eq("T1 SRC", r, 32'h000 + 32);
        cfg_read(R_DST, r); expect_eq("T1 DST", r, 32'h200 + 32);
        cfg_read(R_LEN, r); expect_eq("T1 LEN", r, 0);
        clear_status;

        $display("T2: copy 1 word");
        init_mem;
        run_dma(32'h010, 32'h210, 1, 1, 1, 0);
        expect_eq("T2 status", last_st, ST_DONE);
        check_copy("T2 du lieu", 4, 132, 1);
        expect_eq("T2 khong ghi lan", mem[133], 0);
        clear_status;

        $display("T3: LEN=0, START phai bi bo qua");
        init_mem;
        run_dma(32'h000, 32'h200, 0, 1, 1, 0);
        expect_eq("T3 status", last_st, 0);
        expect_eq("T3 dich khong doi", mem[128], 0);

        $display("T4: copy 100 word, tre ngau nhien 0..5");
        max_lat = 5; init_mem;
        run_dma(32'h000, 32'h200, 100, 1, 1, 0);
        expect_eq("T4 status", last_st, ST_DONE);
        check_copy("T4 du lieu", 0, 128, 100);
        clear_status;

        $display("T5: ngat irq");
        max_lat = 1; init_mem;
        run_dma(32'h000, 32'h200, 4, 1, 1, 1);
        expect_eq("T5 irq len", {31'd0, irq}, 1);
        check_copy("T5 du lieu", 0, 128, 4);
        cfg_write(R_STATUS, 32'h2);
        expect_eq("T5 irq ha", {31'd0, irq}, 0);

        $display("T6: ghi cau hinh khi dang BUSY phai bi bo qua");
        max_lat = 6; init_mem;
        cfg_write(R_SRC, 32'h000);
        cfg_write(R_DST, 32'h200);
        cfg_write(R_LEN, 16);
        cfg_write(R_CTRL, 32'hD);               // START | SRC_INC | DST_INC
        cfg_write(R_SRC, 32'hDEADBEEF);         // bi bo qua
        cfg_write(R_LEN, 32'd99);               // bi bo qua
        wait_idle;
        expect_eq("T6 status", last_st, ST_DONE);
        check_copy("T6 du lieu", 0, 128, 16);
        cfg_read(R_SRC, r); expect_eq("T6 SRC", r, 32'h040);
        cfg_read(R_LEN, r); expect_eq("T6 LEN", r, 0);
        clear_status;

        $display("T7: loi bus khi doc word 3");
        max_lat = 2; init_mem;
        err_en = 1; err_addr = 32'h00C;
        run_dma(32'h000, 32'h200, 8, 1, 1, 0);
        expect_eq("T7 status", last_st, ST_ERR);
        check_copy("T7 3 word dau", 0, 128, 3);
        expect_eq("T7 word 3 chua ghi", mem[131], 0);
        expect_eq("T7 word 4 chua ghi", mem[132], 0);
        clear_status;
        cfg_read(R_STATUS, r); expect_eq("T7 xoa ERR", r, 0);
        err_en = 0;

        $display("T8: nguon co dinh (SRC_INC=0), dich tang");
        max_lat = 2; init_mem;
        run_dma(32'h014, 32'h200, 4, 0, 1, 0);
        expect_eq("T8 status", last_st, ST_DONE);
        expect_eq("T8 word 0", mem[128], mem[5]);
        expect_eq("T8 word 1", mem[129], mem[5]);
        expect_eq("T8 word 2", mem[130], mem[5]);
        expect_eq("T8 word 3", mem[131], mem[5]);
        cfg_read(R_SRC, r); expect_eq("T8 SRC", r, 32'h014);
        clear_status;

        $display("T9: dich co dinh (DST_INC=0), nguon tang");
        init_mem;
        run_dma(32'h000, 32'h200, 4, 1, 0, 0);
        expect_eq("T9 status", last_st, ST_DONE);
        expect_eq("T9 word cuoi", mem[128], mem[3]);
        expect_eq("T9 khong ghi lan", mem[129], 0);
        cfg_read(R_DST, r); expect_eq("T9 DST", r, 32'h200);
        clear_status;

        if (errors == 0) $display("PASS: tat ca test dat");
        else             $display("FAIL: %0d loi", errors);
        $finish;
    end

    initial begin
        #50_000_000;
        $display("FAIL: watchdog het thoi gian");
        $finish;
    end
endmodule
