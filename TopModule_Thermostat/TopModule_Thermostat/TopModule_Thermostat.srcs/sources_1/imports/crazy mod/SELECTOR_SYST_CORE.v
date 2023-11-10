`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Usai Giovanni
// 
// Create Date: 18.05.2023 15:57:51
// Design Name: 
// Module Name: SELECTOR
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


module SELECTOR_SYST_CORE(
input wire clk,rst,
input wire DECR,INCR,
input wire CONF, 
input wire ID_SW, 
input wire [4:0] DT,//GLI INPUT SONO DIRETTAMENTE QUELLI PROVENIENTI DA SCHEDA CHE VENGONO POI SMISTATI IN CELLA O MANOR
output wire DECR_MAN,INCR_MAN, DECR_CEL, INCR_CEL,
output wire CONF_MAN, CONF_CEL, 
output wire [4:0] DT_MAN, DT_CEL
);

parameter SIZE_DATA = 8;

reg[SIZE_DATA-1:0] st_cel,  st_man;
wire[SIZE_DATA-1:0] st_cel_nxt, st_man_nxt;

MUX_2 #(.DW(SIZE_DATA)) MUX_MAN(.A({DECR, INCR, CONF, DT}), .B(st_man), .SEL(~ID_SW), .OUT(st_man_nxt));
MUX_2 #(.DW(SIZE_DATA)) MUX_CELL(.A({DECR, INCR, CONF, DT}), .B(st_cel), .SEL(ID_SW), .OUT(st_cel_nxt));


Driver_MANOR_CELLAR #(.SIZE_IN(SIZE_DATA)) Dr_MANOR(.in(st_man), .DECR(DECR_MAN), .INCR(INCR_MAN), .CONF(CONF_MAN), .DT(DT_MAN));

Driver_MANOR_CELLAR #(.SIZE_IN(SIZE_DATA)) Dr_CELLAR(.in(st_cel), .DECR(DECR_CEL), .INCR(INCR_CEL), .CONF(CONF_CEL), .DT(DT_CEL));

//Registro per CELLAR
always@(posedge clk, posedge rst)begin
if(rst == 1'b1)st_cel <= {SIZE_DATA{1'b0}};
else st_cel <= st_cel_nxt;
end

//Registro per MANOR
always@(posedge clk, posedge rst)begin
if(rst == 1'b1)st_man <= {SIZE_DATA{1'b0}};
else st_man <= st_man_nxt;
end


endmodule