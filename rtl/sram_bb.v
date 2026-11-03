// Hop den (chi khai bao cong) cua macro SRAM OpenRAM 2 KB trong PDK sky130.
// Chi dung cho LibreLane (lint, tong hop). Mo phong dung model hanh vi cua PDK:
//   libs.ref/sky130_sram_macros/verilog/sky130_sram_2kbyte_1rw1r_32x512_8.v
(* blackbox *)
module sky130_sram_2kbyte_1rw1r_32x512_8 (
`ifdef USE_POWER_PINS
    inout         vccd1,
    inout         vssd1,
`endif
    input         clk0,      // cong 0: doc/ghi
    input         csb0,      // chon chip, muc thap
    input         web0,      // 0 = ghi, 1 = doc
    input  [3:0]  wmask0,    // chon byte khi ghi
    input  [8:0]  addr0,     // 512 word
    input  [31:0] din0,
    output [31:0] dout0,
    input         clk1,      // cong 1: chi doc (khong dung)
    input         csb1,
    input  [8:0]  addr1,
    output [31:0] dout1
);
endmodule
