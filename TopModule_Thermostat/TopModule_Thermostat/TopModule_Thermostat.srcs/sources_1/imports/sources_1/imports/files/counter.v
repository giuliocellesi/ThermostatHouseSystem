`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2021 17:00:41
// Design Name: 
// Module Name: counter
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


module counter # (parameter MAX=10,
                  parameter N_BIT=4)(
input wire clk, rst,
input wire en, clear,
output wire hit,
output reg [N_BIT-1:0] count
    );
    
reg [N_BIT-1:0] count_nxt;

always@(posedge clk, posedge rst)
if (rst==1'b1) count<=MAX-1;
else count<=count_nxt;  

always@(en,count, clear)
if (clear==1) count_nxt = MAX-1;
else if (en==1'b0) count_nxt=count;
     else if (count=={N_BIT{1'b0}}) count_nxt=MAX-1;
         else count_nxt=count-1;
         
assign hit=(count=={N_BIT{1'b0}})?1'b1:1'b0;
endmodule

module counter_up # (parameter MAX=10,
                  parameter N_BIT=4)(
input wire clk, rst,
input wire en,
output reg [N_BIT-1:0] count
    );
    
reg [N_BIT-1:0] count_nxt;

always@(posedge clk, posedge rst)
if (rst==1'b1) count<={N_BIT{1'b0}};
else count<=count_nxt;  

always@(en,count)
if (en==1'b0) count_nxt=count;
     else if (count==MAX-1) count_nxt={N_BIT{1'b0}};
         else count_nxt=count+1;   
endmodule

