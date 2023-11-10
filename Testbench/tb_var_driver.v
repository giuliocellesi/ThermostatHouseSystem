`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2023 10:26:14
// Design Name: 
// Module Name: tb_var_driver
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


module tb_var_driver;

reg clk, rst;
reg run;
reg start;
reg confM;
reg al, wsc, wsm, ss, st;

wire hitC, hitM;    
wire[3:0] out_var;

VAR_DRIVER var_driver(.clk(clk), .rst(rst), .run(run),.start(start), .confM(confM),.al(al), .wsc(wsc), .wsm(wsm), .ss(ss), .st(st), .hitC_var(hitC), .hitM_var(hitM), .out_var(out_var));

always #2 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
run = 1'b0;
start = 1'b0;
confM = 1'b0;
al = 1'b0;
wsc = 1'b0;
wsm = 1'b0;

ss = 1'b0;
st = 1'b0;


#20 rst =1'b0;

/*CON RUN A 1*/
#15 run = 1'b1;

#20 confM = 1'b1;
#10 confM = 1'b0;

#15 start = 1'b1;
#25 start = 1'b0;

#30 al = 1'b1;

#15 al = 1'b0;

#20 ss = 1'b1;
#25 ss = 1'b0;

#30 st = 1'b1;
#25 st = 1'b0;

#20 ss = 1'b1;
#25 ss = 1'b0;

#30 st = 1'b1;
#25 st = 1'b0;

#50 wsc = 1'b1;
#50 wsc = 1'b0;

#50 wsm = 1'b1;
#50 wsm = 1'b0;

/*CON RUN A 0*/
#300 run = 1'b0;

#15 start = 1'b1;
#25 start = 1'b0;

#20 confM = 1'b1;
#10 confM = 1'b0;

#30 al = 1'b1;

#15 al = 1'b0;

#20 ss = 1'b1;
#25 ss = 1'b0;

#30 st = 1'b1;
#25 st = 1'b0;

#20 ss = 1'b1;
#25 ss = 1'b0;

#30 st = 1'b1;
#25 st = 1'b0;

#50 wsc = 1'b1;
#50 wsc = 1'b0;

#50 wsm = 1'b1;
#50 wsm = 1'b0;

#50 $stop;
end
endmodule
