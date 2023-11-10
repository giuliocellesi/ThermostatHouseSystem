`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2023 16:02:13
// Design Name: 
// Module Name: tb_MANOR
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


module tb_MANOR;
reg clk,rst;
reg DECR,INCR,SW_START;
reg CONF,SS,ST,nWSM;
reg [4:0] DT;
wire nWS;
wire [4:0]DTF;
wire [5:0]RTR;
wire[1:0] LED;

TOP_MODULE_MANOR DUTM(.clk(clk),.rst(rst),.DECR(DECR),.INCR(INCR),.SW_START(SW_START),.CONF(CONF),.SS(SS),.ST(ST),.nWSM(nWSM),.DT(DT),.nWS(nWS),.RTR(RTR),.DTF(DTF),.LED(LED));

always
#5 clk=~clk;

initial
begin
clk=1'b0;
rst=1'b1;
DECR=1'b0;
INCR=1'b0;
SW_START=1'b0;
CONF=1'b0;
SS=1'b0;
ST=1'b0;
nWSM=1'b0;
DT=5'd8;
#20 rst=1'b0;
#150 CONF=1'b1;
#150 CONF=1'b0;
#50 SW_START = 1'b1;
#400 SW_START = 1'b0;
#300 SW_START = 1'b1;
#1000 nWSM=1'b1;
#100 SS=1'b1;
#50 ST=1'b1;
#2000 nWSM = 1'b0;

#500 $stop;
end
endmodule
