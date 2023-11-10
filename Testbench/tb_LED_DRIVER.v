`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2023 16:39:26
// Design Name: 
// Module Name: tb_LED_DRIVER
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


module tb_LED_DRIVER;

reg clk, rst;
reg[1:0] LED;
wire[15:0] LED_OUT;

LED_DRIVER ledD(.clk(clk), .rst(rst), .LED(LED), .LED_OUT(LED_OUT));

always #1 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
LED = 2'b00; //OFF

#20 rst = 1'b0;

#200 LED = 2'b01;
#200 LED = 2'b10;
#200 LED = 2'b11;
#200 LED = 2'b00;
#200 $stop;
end
endmodule
