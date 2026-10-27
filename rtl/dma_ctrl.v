`timescale 1ns/1ps
module dma_ctrl (
    input  wire        clk, rst,
    // Wishbone slave: CPU cấu hình
    input  wire        s_cyc, s_stb, s_we,
    input  wire [4:2]  s_adr,
    input  wire [31:0] s_dat_i,
    output reg  [31:0] s_dat_o,
    output reg         s_ack,
    // Wishbone master: DMA tự truy cập bus
    output reg         m_cyc, m_stb, m_we,
    output wire [31:0] m_adr, m_dat_o,
    output wire [3:0]  m_sel,
    input  wire [31:0] m_dat_i,
    input  wire        m_ack, m_err,
    output wire        irq
);
    localparam IDLE=0, RD_REQ=1, RD_WAIT=2, WR_REQ=3, WR_WAIT=4;
    reg [2:0]  st;
    reg [31:0] src, dst, len, data;
    reg        busy, done, err, irq_en, src_inc, dst_inc;

    assign m_sel   = 4'hF;
    assign m_dat_o = data;
    assign m_adr   = m_we ? dst : src;
    assign irq     = done & irq_en;

    wire cfg_wr = s_cyc & s_stb & s_we & ~s_ack;
    wire rd_ok  = (st == RD_WAIT) & m_ack & ~m_err;
    wire wr_ok  = (st == WR_WAIT) & m_ack & ~m_err;

    always @(*) case (s_adr)
        3'd0: s_dat_o = {28'd0, dst_inc, src_inc, irq_en, 1'b0};
        3'd1: s_dat_o = {29'd0, err, done, busy};
        3'd2: s_dat_o = src;
        3'd3: s_dat_o = dst;
        3'd4: s_dat_o = len;
        default: s_dat_o = 32'd0;
    endcase

    // Datapath: không reset
    always @(posedge clk) begin
        if (cfg_wr && !busy && s_adr == 3'd2) src <= s_dat_i;
        if (cfg_wr && !busy && s_adr == 3'd3) dst <= s_dat_i;
        if (rd_ok) data <= m_dat_i;
        if (wr_ok) begin
            if (src_inc) src <= src + 4;
            if (dst_inc) dst <= dst + 4;
        end
    end

    // Điều khiển: có reset
    always @(posedge clk) begin
        if (rst) begin
            st <= IDLE; busy <= 0; done <= 0; err <= 0;
            irq_en <= 0; src_inc <= 0; dst_inc <= 0; len <= 0;
            m_cyc <= 0; m_stb <= 0; m_we <= 0; s_ack <= 0;
        end else begin
            s_ack <= s_cyc & s_stb & ~s_ack;

            if (cfg_wr) case (s_adr)
                3'd0: begin
                    irq_en <= s_dat_i[1]; src_inc <= s_dat_i[2]; dst_inc <= s_dat_i[3];
                    if (s_dat_i[0] && !busy && len != 0) begin
                        busy <= 1; done <= 0; err <= 0; st <= RD_REQ;
                    end
                end
                3'd1: begin
                    if (s_dat_i[1]) done <= 0;
                    if (s_dat_i[2]) err  <= 0;
                end
                3'd4: if (!busy) len <= s_dat_i;
                default: ;
            endcase

            case (st)
                IDLE: ;
                RD_REQ: begin
                    m_cyc <= 1; m_stb <= 1; m_we <= 0;
                    st <= RD_WAIT;
                end
                RD_WAIT: if (m_ack | m_err) begin
                    m_cyc <= 0; m_stb <= 0;
                    if (m_err) begin err <= 1; busy <= 0; st <= IDLE; end
                    else st <= WR_REQ;
                end
                WR_REQ: begin
                    m_cyc <= 1; m_stb <= 1; m_we <= 1;
                    st <= WR_WAIT;
                end
                WR_WAIT: if (m_ack | m_err) begin
                    m_cyc <= 0; m_stb <= 0; m_we <= 0;
                    if (m_err) begin err <= 1; busy <= 0; st <= IDLE; end
                    else begin
                        len <= len - 1;
                        if (len == 1) begin busy <= 0; done <= 1; st <= IDLE; end
                        else st <= RD_REQ;
                    end
                end
                default: st <= IDLE;
            endcase
        end
    end
endmodule
