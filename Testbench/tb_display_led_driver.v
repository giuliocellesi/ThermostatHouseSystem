`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2023 22:44:19
// Design Name: 
// Module Name: tb_display_led_driver
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_display_led_driver;

reg clk, rst;
reg [1:0] LED_MANOR, LED_CELLAR;
reg[4:0] DTF_MANOR,DTF_CELLAR; 
reg[5:0] RTR_MANOR,RTR_CELLAR;
reg nWSC,nWSM, ID_SW;

wire [1:0] LEDF;
wire [11:0] out;

DISPLAY_LED_DRIVER DISP_LED_DRIV(.clk(clk), .rst(rst), .LEDM(LED_MANOR), .LEDC(LED_CELLAR), .DTF_MANOR(DTF_MANOR),
    .DTF_CELLAR(DTF_CELLAR), .RTR_MANOR(RTR_MANOR), .RTR_CELLAR(RTR_CELLAR), .nWSC(nWSC), .nWSM(nWSM), 
    .ID_SW(ID_SW), .LEDF(LEDF), .out(out));
    
always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
LED_MANOR = 2'b10;
LED_CELLAR = 2'b01;
DTF_MANOR = 5'b00111;
DTF_CELLAR = 5'b11000;
RTR_MANOR = 6'b000111;
RTR_CELLAR = 6'b111000;
nWSC = 1'b1;
nWSM = 1'b1;
ID_SW = 1'b0;

#50 rst = 1'b0;
#200 ID_SW = 1'b1;
#10 nWSC = 1'b0;
#20 begin
LED_MANOR = LED_MANOR + 2'b1;
LED_CELLAR = LED_CELLAR - 2'b1;
DTF_MANOR = DTF_MANOR + 5'd2;
DTF_CELLAR = DTF_CELLAR - 5'd2;
RTR_MANOR = DTF_MANOR +6'd3;
RTR_CELLAR = RTR_CELLAR - 6'd3;
end
#100 ID_SW = 1'b0;
#10 nWSC = 1'b1; nWSM = 1'b1;
#20 nWSM = 1'b0;

#50 LED_CELLAR = 2'b11;

#500 ID_SW = 1'b1;
#100 $stop;
end
endmodule
