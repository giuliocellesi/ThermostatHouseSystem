`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Antonio Ledda, Ilaria Nardi
// 
// Create Date: 22.03.2023 17:23:04
// Design Name: 
// Module Name: MUX_2
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


module MUX_2#(parameter DW=1)(
input wire [DW-1:0] A,B,
input wire SEL,
output reg [DW-1:0] OUT
);

    always@(SEL,A,B) begin
        if(SEL == 1'b0) OUT = A;
        else OUT = B;
    end

endmodule
