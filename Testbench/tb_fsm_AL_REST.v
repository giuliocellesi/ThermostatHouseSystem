`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2023 16:36:09
// Design Name: 
// Module Name: fsm_modified
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

module tb_fsm_AL_RST;

reg clk, rst;
reg start, in;
wire hit;
wire[3:0]out;

fsmVAR #(.ID_1(1), .ID_2(2)) fsmAR(.clk(clk), .rst(rst), .start(start), .in(in), .hit(hit), .out(out));

always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
start = 1'b0;
in = 1'b0;


#12 rst = 1'b0;

#30 in = 1'b1;
#25 start = 1'b1;

#25 in = 1'b0;

#50 start= 1'b0;
#50 in = 1'b1;
#50 in = 1'b0;

#40 start = 1'b1;
#50 in = 1'b1;
#50 in = 1'b0;
#30 $stop; 
end

endmodule