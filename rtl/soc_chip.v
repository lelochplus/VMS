`timescale 1ns/1ps
// Chip ASIC day du: soc_core + ROM chua firmware + SRAM 2 KB (macro OpenRAM cua sky130).
// Ban do bo nho trong vung 0x0xxx_xxxx (soc_core dua vung nay ra cong ext_*):
//   0x0000_0000 - 0x0000_0FFF  ROM 4 KB  (ma lenh, vector reset 0x00, vector ngat 0x10)
//   0x0000_1000 - 0x0000_17FF  SRAM 2 KB (du lieu, stack)
//   dia chi khac               tra ack, du lieu 0
module soc_chip #(
    parameter CLK_DIV = 347            // 40 MHz / 115200 baud
) (
    input  wire clk,
    input  wire rst,                   // reset muc cao
    output wire uart_tx,
    output wire trap
);
    wire        ext_cyc, ext_stb, ext_we;
    wire [3:0]  ext_sel;
    wire [31:0] ext_adr, ext_dat_o, ext_dat_i;
    reg         ext_ack;

`ifdef GL
    soc_core core (                    // netlist sau tong hop: CLK_DIV co dinh luc tong hop
`else
    soc_core #(.CLK_DIV(CLK_DIV)) core (
`endif
        .clk(clk), .rst(rst), .uart_tx(uart_tx), .trap(trap),
        .ext_cyc(ext_cyc), .ext_stb(ext_stb), .ext_we(ext_we),
        .ext_sel(ext_sel), .ext_adr(ext_adr), .ext_dat_o(ext_dat_o),
        .ext_dat_i(ext_dat_i), .ext_ack(ext_ack)
    );

    // Giao dich moi: bat dau o chu ky co cyc & stb, ack o chu ky ke tiep
    wire go       = ext_cyc & ext_stb & ~ext_ack;
    wire sel_rom  = (ext_adr[27:12] == 16'h0000);
    wire sel_sram = (ext_adr[27:11] == 17'h00002);

    always @(posedge clk) begin
        if (rst) ext_ack <= 1'b0;
        else     ext_ack <= go;
    end

    // ROM: mach to hop sinh tu firmware, dau ra chot lai mot chu ky
    wire [31:0] rom_data;
    reg  [31:0] rom_q;
    boot_rom rom (.addr(ext_adr[11:2]), .data(rom_data));
    always @(posedge clk) if (go) rom_q <= rom_data;

    // SRAM: chot dia chi/du lieu o canh len, doc xong truoc canh len ke tiep
    wire [31:0] sram_q;
    sky130_sram_2kbyte_1rw1r_32x512_8
`ifdef SIM
        #(.VERBOSE(0))                 // chi khi mo phong: tat thong bao moi lan doc/ghi cua model
`endif
        sram0 (
        .clk0(clk), .csb0(~(go & sel_sram)), .web0(~ext_we), .wmask0(ext_sel),
        .addr0(ext_adr[10:2]), .din0(ext_dat_o), .dout0(sram_q),
        .clk1(1'b0), .csb1(1'b1), .addr1(9'd0), .dout1()
    );

    assign ext_dat_i = sel_sram ? sram_q : sel_rom ? rom_q : 32'h0;
endmodule
