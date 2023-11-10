`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo
// 
// Create Date: 05.04.2023 22:16:13
// Design Name: 
// Module Name: mux
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


module mux #(
parameter N=2
)(
input wire [N-1:0] i0,i1,
input sel,
output reg [N-1:0] o
    );
   

always@(i0,i1,sel)
if(sel==1'b1) o=i1;
else o=i0; 
   
endmodule
