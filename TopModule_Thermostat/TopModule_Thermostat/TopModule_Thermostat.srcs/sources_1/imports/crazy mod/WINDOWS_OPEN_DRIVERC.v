`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Paolo Galiano Bove, Ilaria Nardi, Antonio Ledda
// 
// Create Date: 22.03.2023 16:04:18
// Design Name: 
// Module Name: WINDOWS_OPEN_DRIVER
// Project Name: Thermostat Control System
// Target Devices: Basys 3
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


module WINDOWS_OPEN_DRIVERC(
input wire clk,rst,active,
input wire [5:0] ETR,RTR,
output reg CLR,
output wire T_WO,
output reg [1:0]LED,
output reg [2:0] ID_WO
);

reg [2:0] id_wo_nxt;

//ID_WO logic
always@(posedge clk,posedge rst)
if(rst==1'b1) ID_WO<=3'b000;
else ID_WO<=id_wo_nxt;

//id_wo_nxt output logic
always@(ETR,RTR)
if(ETR>RTR) id_wo_nxt=3'b001;
else if(RTR>ETR) id_wo_nxt=3'b101;
else id_wo_nxt=3'b000;

//CLR logic
always@(ID_WO,id_wo_nxt)
if(ID_WO==3'b001 & id_wo_nxt==3'b101) CLR=1'b1;
else if(ID_WO==3'b101 & id_wo_nxt==3'b001) CLR=1'b1;
else CLR=1'b0;

//T_WO logic
assign T_WO = 1'b0;
//allarme attivo
always@(active)
if(active==1'b1) LED=2'b11;
else LED=2'b00;


endmodule



