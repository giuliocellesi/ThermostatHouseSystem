`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 22.05.2023 17:37:18
// Design Name: 
// Module Name: Slave_7SD
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


module Slave_7SD(
input wire clk,rst,
input wire o_RX_DV,
input wire [19:0] o_RX_BYTE,
output wire WS,
output wire [4:0] DTF,
output  wire [5:0] RTR
    );
    reg [19:0] data_reg;
    always@(posedge clk, posedge rst)
    if(rst) data_reg <= 20'd0;
    else if(o_RX_DV) data_reg <= o_RX_BYTE;
    
    //Assegnamo a DTF, RTR, WS i valori corrispondenti in arrivo dall'SPI slave
    assign DTF = data_reg[19:15];
    assign RTR = data_reg[14:9];
    assign WS = data_reg[8];
    
endmodule
