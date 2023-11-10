`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 30.05.2023 16:51:04
// Design Name: 
// Module Name: Slave_buttons
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


module Slave_buttons(
    input wire clk,rst,
    input wire o_RX_DV,
    input wire [3:0] data,
    output reg [3:0] data_stored //Dato che verrà poi spachettato in {sw_start, restart, window cellar, window manor} e inviato a system core
    );
    
    always@ (posedge  clk, posedge rst)
    if(rst) data_stored <= 4'b0000;
    else if(o_RX_DV) data_stored <= data;
    
endmodule
