`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2023 16:16:40
// Design Name: 
// Module Name: TEST_BENCH_FSM
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


module TEST_BENCH_FSM();
reg clk,rst;
reg active;
reg WS,RUN;
reg [2:0] DELTA;
wire [1:0] LED,ID_WC;
wire T_WC;
wire CLR_WC;

fsm_modified tb(.clk(clk),.rst(rst), .active(active), .RUN(RUN),.WS(~WS),.DELTA(DELTA),.LED(LED),.ID_WC(ID_WC),.T_WC(T_WC),.CLR_WC(CLR_WC));

always #5 clk=~clk;


initial
begin
clk=1'b0;
rst=1'b1;
active = 1'b0;
RUN=1'b0;
WS=1'b0;
DELTA=3'b000;

#13 rst=1'b0;

#50 RUN = 1'b1;
#70 @(negedge clk) DELTA=3'b100;
#20 @(negedge clk) DELTA=3'b011;
#20 @(negedge clk) DELTA=3'b100;
#20 @(negedge clk) DELTA=3'b110;
#20 @(negedge clk) active = 1'b1;
#20 @(negedge clk) DELTA=3'b000;

#20 @(negedge clk) DELTA=3'b001;
#20 @(negedge clk) DELTA=3'b011;
#20 @(negedge clk) DELTA=3'b100;
#20 @(negedge clk) DELTA=3'b110;

#20 @(negedge clk) active = 1'b0;
#50 WS = 1'b1;
#20 @(negedge clk) DELTA=3'b000;

#20 @(negedge clk) DELTA=3'b001;
#20 @(negedge clk) DELTA=3'b000;
#20 @(negedge clk) DELTA=3'b011;
#20 @(negedge clk) DELTA=3'b100;
#20 @(negedge clk) DELTA=3'b110;
#20 @(negedge clk) active = 1'b1;


#20 @(negedge clk) DELTA=3'b001;
#20 @(negedge clk) DELTA=3'b011;
#20 @(negedge clk) DELTA=3'b100;
#20 @(negedge clk) DELTA=3'b000;
#20 @(negedge clk) DELTA=3'b110;

#20 @(negedge clk) active = 1'b0;


#20 @(negedge clk) DELTA=3'b001;
#20 @(negedge clk) DELTA=3'b011;
#20 @(negedge clk) DELTA=3'b100;
#20 @(negedge clk) DELTA=3'b000;
#20 @(negedge clk) DELTA=3'b110;
//#20 @(negedge clk) active = 1'b1;


end
endmodule

