`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2023 16:12:17
// Design Name: 
// Module Name: tb_top_thermostat
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


module tb_top_thermostat;
reg clk, rst;
reg DECR, INCR, CONF, SW_START, SS, ST, WS_MANOR, WS_CELLAR;
reg ID_SW, RESTART;
reg [4:0] DT;
//wire AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG,CW;
wire TX;
wire[15:0] LED_OUT;

Top_Thermostat TOP_TH(.clk(clk), .rst(rst), .DECR(DECR), .INCR(INCR), .CONF(CONF), .SW_START(SW_START), .SS(SS),
                               .ST(ST), .WS_MANOR(WS_MANOR), .WS_CELLAR(WS_CELLAR), .ID_SW(ID_SW), .RESTART(RESTART), .DT(DT),
                               //.AN0(AN0), .AN1(AN1), .AN2(AN2), .AN3(AN3), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .CW(CW),
                               .TX(TX), .LED_OUT(LED_OUT));
                               
always #1 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
DECR = 1'b0;
INCR = 1'b0;
CONF = 1'b0;
SW_START = 1'b0;
SS = 1'b0;
ST = 1'b0;
WS_MANOR= 1'b0;
WS_CELLAR = 1'b0;
ID_SW= 1'b0;
RESTART= 1'b0;
DT = 5'b01010;

#50 rst = 1'b0;


#100 CONF = 1'b1;
#500 CONF = 1'b0;   

#6000 ID_SW = 1'b1;



#6000 CONF = 1'b1;
//#20 CONF = 1'b0;
//#30 ID_SW = 1'b0;
#20 CONF = 1'b0;

#6000 SW_START = 1'b1;
/*
#150 SS = 1'b1;
#210 ST = 1'b1;
#200 WS_CELLAR = 1'b1;
#30 ID_SW = 1'b0;
#100 INCR = 1'b1;
#10 INCR = 1'b0;
#10 INCR = 1'b1;
#10 INCR = 1'b0;
#10 INCR = 1'b1;
#10 INCR = 1'b0;
#10 DECR = 1'b1;
#10 DECR = 1'b0;
#1000 SW_START = 1'b0;
#200 WS_MANOR = 1'b1;
#2000 WS_CELLAR = 1'b0;
#200 RESTART = 1'b1;
*/


#15000 $stop;

end                 
endmodule
