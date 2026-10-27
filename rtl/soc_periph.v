`timescale 1ns/1ps
// RAM Wishbone, ghi theo byte (sel), ack sau 1 chu kỳ.
// Tách 4 làn 8 bit, mỗi làn một mảng không có byte-enable, để Yosys dùng BSRAM
// thường thay cho chế độ X9 (SPX9) - chế độ này chạy sai trên GW2A khi nạp qua apicula.
// INIT_FILE là tiền tố: làn k đọc <INIT_FILE>k.hex (Makefile cắt từ fw.bin).
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
    reg [7:0] m0 [0:WORDS-1];
    reg [7:0] m1 [0:WORDS-1];
    reg [7:0] m2 [0:WORDS-1];
    reg [7:0] m3 [0:WORDS-1];
    wire [$clog2(WORDS)-1:0] idx = adr[$clog2(WORDS)+1:2];
    wire go = cyc & stb & ~ack;
    integer i;

    initial begin
        for (i = 0; i < WORDS; i = i + 1) begin m0[i] = 0; m1[i] = 0; m2[i] = 0; m3[i] = 0; end
        if (INIT_FILE != "") begin
            $readmemh({INIT_FILE, "0.hex"}, m0);
            $readmemh({INIT_FILE, "1.hex"}, m1);
            $readmemh({INIT_FILE, "2.hex"}, m2);
            $readmemh({INIT_FILE, "3.hex"}, m3);
        end
    end

    always @(posedge clk) begin
        ack <= go;
        if (go) begin
            if (we & sel[0]) m0[idx] <= dat_i[7:0];
            if (we & sel[1]) m1[idx] <= dat_i[15:8];
            if (we & sel[2]) m2[idx] <= dat_i[23:16];
            if (we & sel[3]) m3[idx] <= dat_i[31:24];
            dat_o <= {m3[idx], m2[idx], m1[idx], m0[idx]};
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
