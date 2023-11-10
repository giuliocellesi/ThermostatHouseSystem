`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2023 17:24:38
// Design Name: 
// Module Name: tb_top_alarm
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


module tb_top_alarm;

reg clk, rst, restart, ws, CLR_WS, RUN;
reg[4:0] DTF;
reg[5:0] RTR;
wire active;

top_alarm top_al(.clk(clk), .rst(rst), .restart(restart), .ws(ws), .CLR_WC(CLR_WS), .RUN(RUN), .DTF(DTF), .RTR(RTR), .active(active));

always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
restart = 1'b0;
ws = 1'b0;
CLR_WS = 1'b0;
RUN = 1'b0;
DTF = 5'b01100;
RTR = 6'b01100;


#20 rst = 1'b0;
#10 ws = 1'b1;
#10 RUN= 1'b1;
#30 DTF = 5'b00111;
#25 ws = 1'b0;
#1200 restart = 1'b1;
#50 restart = 1'b0;


#75 ws = 1'b1;
#100 restart = 1'b1; 
#20 restart = 1'b0;

#500 $stop;
end
endmodule
