// RAM Wishbone, hỗ trợ ghi theo byte (sel), ack sau 1 chu kỳ
module wb_ram #(
    parameter WORDS     = 1024,
    parameter INIT_FILE = ""
) (
    input  wire        clk,
    input  wire        cyc, stb, we,
    input  wire [3:0]  sel,
    input  wire [31:0] adr,
    input  wire [31:0] dat_i,
    output reg  [31:0] dat_o,
    output reg         ack
);
    reg [31:0] mem [0:WORDS-1];
    wire [$clog2(WORDS)-1:0] idx = adr[$clog2(WORDS)+1:2];
    reg  [31:0] w;
    integer i;

    initial begin
        for (i = 0; i < WORDS; i = i + 1) mem[i] = 32'h0;
        if (INIT_FILE != "") $readmemh(INIT_FILE, mem);
    end

    always @(posedge clk) begin
        ack <= cyc & stb & ~ack;
        if (cyc & stb & ~ack) begin
            w = mem[idx];
            if (we) begin
                if (sel[0]) w[7:0]   = dat_i[7:0];
                if (sel[1]) w[15:8]  = dat_i[15:8];
                if (sel[2]) w[23:16] = dat_i[23:16];
                if (sel[3]) w[31:24] = dat_i[31:24];
                mem[idx] <= w;
            end
            dat_o <= mem[idx];
        end
    end
endmodule


// UART chỉ truyền (8N1). Ghi +0x0 để gửi byte, đọc +0x4 bit0 = BUSY.
// Ghi khi đang BUSY bị bỏ qua, nên firmware phải chờ BUSY = 0 trước khi gửi.
module wb_uart_tx #(
    parameter CLK_DIV = 434
) (
    input  wire        clk, rst,
    input  wire        cyc, stb, we,
    input  wire        adr2,           // bit 2 của địa chỉ: 0 = TXDATA, 1 = STATUS
    input  wire [31:0] dat_i,
    output wire [31:0] dat_o,
    output reg         ack,
    output wire        tx
);
    reg [9:0]  shifter;                // {stop, d7..d0, start}, LSB ra trước
    reg [3:0]  bits;                   // số bit còn lại
    reg [15:0] cnt;
    wire busy = (bits != 4'd0);

    assign tx    = shifter[0];
    assign dat_o = adr2 ? {31'd0, busy} : 32'd0;

    always @(posedge clk) begin
        if (rst) begin
            ack <= 1'b0; shifter <= 10'h3FF; bits <= 4'd0; cnt <= 16'd0;
        end else begin
            ack <= cyc & stb & ~ack;
            if (cyc & stb & ~ack & we & ~adr2 & ~busy) begin
                shifter <= {1'b1, dat_i[7:0], 1'b0};
                bits    <= 4'd10;
                cnt     <= CLK_DIV - 1;
            end else if (busy) begin
                if (cnt == 16'd0) begin
                    shifter <= {1'b1, shifter[9:1]};
                    bits    <= bits - 4'd1;
                    cnt     <= CLK_DIV - 1;
                end else begin
                    cnt <= cnt - 16'd1;
                end
            end
        end
    end
endmodule
