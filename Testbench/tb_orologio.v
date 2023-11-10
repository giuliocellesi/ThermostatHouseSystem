`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2023 17:10:58
// Design Name: 
// Module Name: tb_orologio
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


module tb_orologio;

reg clk, rst;
reg en;
wire [2:0] ora;
wire [5:0] min;
wire done;

orologio #(.SX_MAX(6), .DX_MAX(60)) orol (.clk(clk), .rst(rst), .en(en),
.ora(ora), .minuti(min), .done(done));

always #1 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
en = 1'b0;

#10 rst = 1'b0;
#20 en = 1'b1;

end 
endmodule
