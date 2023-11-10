`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2023 18:59:49
// Design Name: 
// Module Name: tb_temp_hour
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


module tb_temp_hour;

reg clk,rst;
reg [3:0] in_var;
reg [5:0] RTRM;
reg [5:0] RTRC;
reg [2:0] h;
reg [5:0] m;
reg hitC, hitM;
wire [3:0] OPCODE;
wire where;
wire[2:0] ora;
wire[5:0] minuti;
wire[5:0] RTRF;

temp_hour tmph(.clk(clk), .rst(rst), .in_var(in_var), .RTRM(RTRM), .RTRC(RTRC), .h(h), .m(m), .hitC(hitC), .hitM(hitM), .OPCODE(OPCODE), .where(where), .ora(ora), .minuti(minuti), .RTRF(RTRF));

always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
in_var = 4'd10;
RTRM = 6'd20;
RTRC = 6'd12;
h = 3'd3;
m = 6'd25;
hitC = 1'b0;
hitM = 1'b0;

#15 @(negedge clk) rst = 1'b0;
#50 @(negedge clk) hitC = 1'b1;
#20 @(negedge clk) hitC = 1'b0;

#50 @(negedge clk) hitM = 1'b1;
#20 @(negedge clk) hitM = 1'b0;
#50 $stop;

end
endmodule
