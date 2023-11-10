`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Usai Giovanni
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

module fsmVAR #(parameter ID_1 = 4'd1, ID_2 = 4'd2)(
    input wire clk, rst,
    input wire start,
    input wire in,
    output reg hit,
    output reg[3:0]out
);

parameter IDLE = 1'b0, ALARM = 1'b1;
reg stato, st_nxt;
reg hit_out;

//REGISTRO STATO
always@(posedge clk, posedge rst)
if(rst == 1'b1) stato <= IDLE;
else if (start) stato <= st_nxt;
else stato<=IDLE;

//logica stato successivo
always@(stato,in)
case(stato)
IDLE: if(in==1'b1) st_nxt=ALARM;
else st_nxt=IDLE;
ALARM: if(in==1'b0) st_nxt=IDLE;
else st_nxt=ALARM;
default: st_nxt=IDLE;
endcase

//logica uscite
always@(stato,in)
case(stato)
IDLE: if (in) hit_out=1'b1;
else hit_out=1'b0;
ALARM:
 if (in) hit_out=1'b0;
else hit_out=1'b1;
default: hit_out=1'b0;
endcase

//logica hit
always@(posedge rst,posedge clk)
if (rst) hit<=1'b0;
else if (start) hit<=hit_out;
else hit<=1'b0;

//logica out
always@(stato)
case(stato)
IDLE: out=ID_2;
ALARM: out=ID_1;
default:out=4'd0;
endcase

endmodule
