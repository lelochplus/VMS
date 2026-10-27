// SoC đầy đủ để mô phỏng: lõi soc_core + RAM
module soc_top #(
    parameter RAM_WORDS = 1024,        // 1024 word = 4 KB
    parameter CLK_DIV   = 434,         // số chu kỳ clk cho mỗi bit UART
    parameter FW_HEX    = ""           // file hex nạp vào RAM khi mô phỏng
) (
    input  wire clk,
    input  wire rst,                   // reset mức cao
    output wire uart_tx,
    output wire trap
);
    wire        ext_cyc, ext_stb, ext_we, ext_ack;
    wire [3:0]  ext_sel;
    wire [31:0] ext_adr, ext_dat_o, ext_dat_i;

    soc_core #(.CLK_DIV(CLK_DIV)) core (
        .clk(clk), .rst(rst), .uart_tx(uart_tx), .trap(trap),
        .ext_cyc(ext_cyc), .ext_stb(ext_stb), .ext_we(ext_we),
        .ext_sel(ext_sel), .ext_adr(ext_adr), .ext_dat_o(ext_dat_o),
        .ext_dat_i(ext_dat_i), .ext_ack(ext_ack)
    );

    wb_ram #(.WORDS(RAM_WORDS), .INIT_FILE(FW_HEX)) ram (
        .clk(clk),
        .cyc(ext_cyc), .stb(ext_stb), .we(ext_we),
        .sel(ext_sel), .adr(ext_adr), .dat_i(ext_dat_o),
        .dat_o(ext_dat_i), .ack(ext_ack)
    );
endmodule
