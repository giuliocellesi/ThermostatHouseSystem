`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 23.03.2023 15:26:17
// Design Name: 
// Module Name: ANODE_DECODER
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


module ANODE_DECODER(
input wire[1:0] SEL,
output reg AN0,AN1,AN2,AN3
    );
    
    //decodifica dell'anodo in base al valore di sel
    always@(SEL)
        case(SEL)
            2'b00: {AN0,AN1,AN2,AN3} = 4'b0111;
            2'b01: {AN0,AN1,AN2,AN3} = 4'b1011;
            2'b10: {AN0,AN1,AN2,AN3} = 4'b1101;
            2'b11: {AN0,AN1,AN2,AN3} = 4'b1110;
            default: {AN0,AN1,AN2,AN3} = 4'b1111;
        endcase
    
endmodule