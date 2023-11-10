`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2023 11:01:56
// Design Name: 
// Module Name: tb_CELLA
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


module tb_CELLA;
reg clk,rst;
reg DECR,INCR,restart;
reg CONF,SS,ST,nWS;
reg [4:0] DT;
wire WS;
wire [4:0]DTF;
wire [5:0]RTR;
wire[1:0] LED;

TOP_MODULE_CELLAR DUT(.clk(clk),.rst(rst),.DECR(DECR),.INCR(INCR),.restart(restart),.CONF(CONF),.SS(SS),.ST(ST),.nWS(nWS),.DT(DT),.WS(WS),.RTR(RTR),.DTF(DTF),.LED(LED));

always
#5 clk=~clk;

initial
begin
clk=1'b0;
rst=1'b1;
DECR=1'b0;
INCR=1'b0;
restart=1'b0;
CONF=1'b0;
SS=1'b0;
ST=1'b0;
nWS=1'b0;
DT=5'd8;
#20 rst=1'b0;
#150 CONF=1'b1;
#150 CONF=1'b0;
#2000 nWS=1'b1;

#100 SS=1'b1;
#50 ST=1'b1;

#1500 restart = 1'b1;
#50 restart = 1'b0;

#500 SS = 1'b0;
#2000 nWS = 1'b0;

#100 restart = 1'b1;
#50 restart = 1'b0;

end

endmodule
