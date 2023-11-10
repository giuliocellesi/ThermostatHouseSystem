`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Usai Giovanni, Bergonzi Giuseppe
// 
// Create Date: 19.05.2023 17:28:50
// Design Name: 
// Module Name: DISPLAY_LED_DRIVER
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


module DISPLAY_LED_DRIVER(
input wire clk,rst,
input wire [1:0] LEDM, LEDC,
input wire[4:0] DTF_MANOR,DTF_CELLAR, 
input wire [5:0] RTR_MANOR,RTR_CELLAR,
input wire nWSC,nWSM, ID_SW, //PRENDE GLI OUTPUT PER IL DISPLAY/LED PROVENIENTI DA MANOR E CELLAR
output reg [1:0] LEDF,// E DECIDE IN BASE ALL'ID_SWITCH QUALI MANDARE AL DISPLAY E AI LED

output reg[11:0] out
);


wire [1:0]LEDF_nxt;
wire [11:0] out_nxt;

MUX_2 #(.DW(2)) MUXled(.A(LEDC), .B(LEDM), .SEL(ID_SW), .OUT(LEDF_nxt));
MUX_2 #(.DW(12)) MUXdisplay(.A({ DTF_CELLAR, RTR_CELLAR, nWSC}), 
        .B({ DTF_MANOR, RTR_MANOR, nWSM}), .SEL(ID_SW), .OUT(out_nxt));

always@(posedge clk,posedge rst)
if (rst)out<=12'd0;
else out<=out_nxt;


always@(posedge clk, posedge rst)
if(rst == 1'b1)LEDF <= 2'b00;
else if(LEDC== 2'b11) LEDF <= 2'b11;
else LEDF <= LEDF_nxt;

endmodule