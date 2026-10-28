// Vỏ top cho Sipeed Tang Nano 20K (GW2AR-18, thạch anh 27 MHz)
// - Reset: tự reset khi cấp nguồn + nút S1 (bấm để chạy lại firmware)
// - UART TX ra chip USB BL616, 115200 baud
// - LED0 nháy ~1,6 Hz: bitstream đã nạp, xung nhịp chạy
// - Gỡ lỗi (LED sáng khi chân ở mức 0): LED1 = CPU trap, LED2 = đang reset, LED3 = UART vừa gửi
module tangnano20k_top #(
    parameter BTN_ACTIVE_HIGH = 1
) (
    input  wire clk, btn_s1,
    output wire uart_tx, led0,
    output wire [2:0] dbg_led
);
    reg [1:0] btn_sync = 2'b00;
    reg [3:0] por = 4'd0;
    always @(posedge clk) begin
        btn_sync <= {btn_sync[0], btn_s1};
        if (por != 4'hF) por <= por + 4'd1;
    end
    wire btn_pressed = BTN_ACTIVE_HIGH ? btn_sync[1] : ~btn_sync[1];
    wire rst = (por != 4'hF) | btn_pressed;

    reg [23:0] blink = 24'd0;
    always @(posedge clk) blink <= blink + 24'd1;
    assign led0 = blink[23];

    // Giữ LED3 sáng ~0,3 s mỗi khi uart_tx xuống 0
    reg [22:0] tx_seen = 23'd0;
    always @(posedge clk) tx_seen <= !uart_tx ? 23'h7FFFFF : tx_seen - {22'd0, |tx_seen};
    wire trap;
    assign dbg_led = ~{|tx_seen, rst, trap};

    soc_top #(.RAM_WORDS(2048), .CLK_DIV(234), .FW_HEX("sw/fw")) soc (
        .clk(clk), .rst(rst), .uart_tx(uart_tx), .trap(trap)
    );
endmodule
