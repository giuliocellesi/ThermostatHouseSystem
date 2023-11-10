`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2020 06:51:22
// Design Name: 
// Module Name: ptr_mng
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


module ptr_mng#(
parameter ADDR_WIDTH=2
)(
input wire clk, rst,
input wire incr, clear,
output reg [ADDR_WIDTH-1:0] ptr
    );
    

//--------------Internal signals---------------- 
reg [ADDR_WIDTH-1:0] ptr_nxt;

always @(posedge clk or posedge rst) 
if(rst==1'b1) ptr<={ADDR_WIDTH{1'b0}};
else ptr<=ptr_nxt; 

always@(ptr or clear or incr) 
if(clear==1'b1) ptr_nxt={ADDR_WIDTH{1'b0}}; 
else if(incr==1'b1) ptr_nxt=ptr+1; 
else ptr_nxt=ptr;
  
endmodule
