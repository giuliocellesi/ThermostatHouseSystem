`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2023 13:43:57
// Design Name: 
// Module Name: tb_fsmCONF
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


module tb_fsmCONF;

reg clk, rst;
reg start, in;
wire hit;
wire[3:0] out;

fsmCONF fsmCNF(.clk(clk), .rst(rst), .start(start), .in(in), .hit(hit), .out(out));

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

#25 in = 1'b1;
#25 in = 1'b0;

#50 start= 1'b0;

#25 in = 1'b1;
#25 in = 1'b0;

#40 start = 1'b1;

#50 in = 1'b1;
#25 in = 1'b0;
#50 in = 1'b1;
#25 in = 1'b0;

#30 $stop; 
end
endmodule