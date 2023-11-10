`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2023 16:33:47
// Design Name: 
// Module Name: tb_fsm_rele
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


module tb_fsm_rele;
reg clk, rst, en, clr;
wire out;
fsm_rele FSM (.clk(clk), .rst(rst), .en(en), .clr(clr), .out(out));

always
#5 clk = ~clk;

initial
begin
clk = 1'b0; rst = 1'b1; en = 1'b0; clr = 1'b0;
#10@(negedge clk) rst = 1'b0;

#50 {en, clr} = 2'b00;
#50 {en,clr} = 2'b01;
#50 {en,clr} = 2'b10;
#50 {en, clr} = 2'b01;
#50 {en,clr} = 2'b11;

end
endmodule
