// Lõi SoC (không RAM): PicoRV32 (Wishbone) + RAM + UART TX + DMA, hai master dùng chung bus qua arbiter
// Bản đồ bộ nhớ:
//   0x0000_0000  RAM (code + dữ liệu)
//   0x1000_0000  UART: +0x0 ghi = gửi byte, +0x4 đọc bit0 = BUSY
//   0x1000_4000  DMA: thanh ghi cấu hình (CTRL, STATUS, SRC, DST, LEN)
module soc_core #(
    parameter CLK_DIV = 434            // số chu kỳ clk cho mỗi bit UART
) (
    input  wire clk,
    input  wire rst,                   // reset mức cao
    output wire uart_tx,
    output wire trap,
    // Cổng Wishbone master ra RAM ngoài (RAM không nằm trong lõi này)
    output wire        ext_cyc, ext_stb, ext_we,
    output wire [3:0]  ext_sel,
    output wire [31:0] ext_adr, ext_dat_o,
    input  wire [31:0] ext_dat_i,
    input  wire        ext_ack
);
    // ---------------- Master 0: CPU ----------------
    wire        cpu_cyc, cpu_stb, cpu_we;
    wire [3:0]  cpu_sel;
    wire [31:0] cpu_adr, cpu_dat_o;
    wire        cpu_ack;
    wire [31:0] bus_dat_r;                 // dữ liệu đọc chung cho cả hai master
    wire        dma_irq;

    picorv32_wb #(
        .PROGADDR_RESET(32'h0000_0000),
        .ENABLE_IRQ(1),
        .LATCHED_IRQ(32'hffff_fff7)       // irq[3] (DMA) theo mức, không chốt
    ) cpu (
        .trap(trap),
        .wb_rst_i(rst), .wb_clk_i(clk),
        .wbm_adr_o(cpu_adr), .wbm_dat_o(cpu_dat_o), .wbm_dat_i(bus_dat_r),
        .wbm_we_o(cpu_we), .wbm_sel_o(cpu_sel), .wbm_stb_o(cpu_stb),
        .wbm_ack_i(cpu_ack), .wbm_cyc_o(cpu_cyc),
        .pcpi_valid(), .pcpi_insn(), .pcpi_rs1(), .pcpi_rs2(),
        .pcpi_wr(1'b0), .pcpi_rd(32'b0), .pcpi_wait(1'b0), .pcpi_ready(1'b0),
        .irq({28'b0, dma_irq, 3'b0}), .eoi(),    
        .trace_valid(), .trace_data(), .mem_instr()
    );

    // ---------------- Master 1: DMA ----------------
    wire        dma_cyc, dma_stb, dma_we;
    wire [3:0]  dma_sel;
    wire [31:0] dma_adr, dma_dat_o;
    wire        dma_ack;

    // ---------------- Arbiter: round-robin theo từng giao dịch ----------------
    reg  own_valid;                        // đang có master giữ bus
    reg  own_dma;                          // 1 = DMA giữ, 0 = CPU giữ
    reg  last_dma;                         // master được phục vụ lần trước
    wire cpu_req = cpu_cyc & cpu_stb;
    wire dma_req = dma_cyc & dma_stb;
    wire pick_dma = dma_req & (~cpu_req | ~last_dma);
    wire use_dma  = own_valid ? own_dma : pick_dma;
    wire bus_ack;

    always @(posedge clk) begin
        if (rst) begin
            own_valid <= 1'b0; own_dma <= 1'b0; last_dma <= 1'b0;
        end else if (!own_valid) begin
            if (cpu_req | dma_req) begin own_valid <= 1'b1; own_dma <= pick_dma; end
        end else if (bus_ack) begin
            own_valid <= 1'b0; last_dma <= own_dma;
        end
    end

    wire        bus_cyc   = use_dma ? dma_cyc   : cpu_cyc;
    wire        bus_stb   = use_dma ? dma_stb   : cpu_stb;
    wire        bus_we    = use_dma ? dma_we    : cpu_we;
    wire [3:0]  bus_sel   = use_dma ? dma_sel   : cpu_sel;
    wire [31:0] bus_adr   = use_dma ? dma_adr   : cpu_adr;
    wire [31:0] bus_dat_w = use_dma ? dma_dat_o : cpu_dat_o;

    assign cpu_ack = bus_ack & ~use_dma;
    assign dma_ack = bus_ack &  use_dma;

    // ---------------- Bộ giải mã địa chỉ ----------------
    wire sel_ram  = (bus_adr[31:28] == 4'h0);
    wire sel_uart = (bus_adr[31:12] == 20'h10000);
    wire sel_dma  = (bus_adr[31:12] == 20'h10004);
    wire sel_none = ~(sel_ram | sel_uart | sel_dma);

    wire        ram_ack, uart_ack, dmas_ack;
    wire [31:0] ram_dat, uart_dat, dmas_dat;
    reg         none_ack;

    // Địa chỉ không có slave: vẫn trả ack (dữ liệu 0) để master không bị treo
    always @(posedge clk) begin
        if (rst) none_ack <= 1'b0;
        else     none_ack <= bus_cyc & bus_stb & sel_none & ~none_ack;
    end

    assign bus_ack = ram_ack | uart_ack | dmas_ack | none_ack;

    assign bus_dat_r = sel_ram  ? ram_dat  :
                       sel_uart ? uart_dat :
                       sel_dma  ? dmas_dat : 32'h0;

    // RAM nằm ngoài lõi: chuyển giao dịch ra cổng ext_*
    assign ext_cyc   = bus_cyc & sel_ram;
    assign ext_stb   = bus_stb & sel_ram;
    assign ext_we    = bus_we;
    assign ext_sel   = bus_sel;
    assign ext_adr   = bus_adr;
    assign ext_dat_o = bus_dat_w;
    assign ram_dat   = ext_dat_i;
    assign ram_ack   = ext_ack;

    wb_uart_tx #(.CLK_DIV(CLK_DIV)) uart (
        .clk(clk), .rst(rst),
        .cyc(bus_cyc & sel_uart), .stb(bus_stb & sel_uart), .we(bus_we),
        .adr2(bus_adr[2]), .dat_i(bus_dat_w),
        .dat_o(uart_dat), .ack(uart_ack), .tx(uart_tx)
    );

    dma_ctrl dma (
        .clk(clk), .rst(rst),
        .s_cyc(bus_cyc & sel_dma), .s_stb(bus_stb & sel_dma), .s_we(bus_we),
        .s_adr(bus_adr[4:2]), .s_dat_i(bus_dat_w),
        .s_dat_o(dmas_dat), .s_ack(dmas_ack),
        .m_cyc(dma_cyc), .m_stb(dma_stb), .m_we(dma_we),
        .m_adr(dma_adr), .m_dat_o(dma_dat_o), .m_sel(dma_sel),
        .m_dat_i(bus_dat_r), .m_ack(dma_ack), .m_err(1'b0),
        .irq(dma_irq)
    );
endmodule
