`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Antonio Ledda, Ilaria Nardi 
// 
// Create Date: 22.03.2023 15:31:41
// Design Name: 
// Module Name: RT_DRIVER
// Project Name: Thermostat Control System
// Target Devices: Basys3
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


module RT_DRIVER(
input wire clk,rst,
input wire HIT,
input wire [2:0] ID,
output reg [5:0] RTR
);

reg [5:0] rtr_nxt;

//RTR logic
always@(posedge clk,posedge rst)
if(rst==1'b1) RTR<=6'd25;
else RTR<=rtr_nxt;

//rtr_nxt logic
always@(HIT,ID,RTR)
if(HIT==1'b1 & ID==3'b001 & RTR<6'd40)       rtr_nxt=RTR+6'd1; 
else if(HIT==1'b1 & ID==3'b101 & RTR>6'd0)   rtr_nxt=RTR-6'd1;
else if(HIT==1'b1 & ID==3'b010 & RTR<6'd30)  rtr_nxt=RTR+6'd2;
else if(HIT==1'b1 & ID==3'b110 & RTR>6'd1)   rtr_nxt=RTR-6'd2;
else rtr_nxt=RTR;

endmodule



