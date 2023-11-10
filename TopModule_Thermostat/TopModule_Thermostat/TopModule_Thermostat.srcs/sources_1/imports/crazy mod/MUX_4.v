`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 21.03.2023 15:43:09
// Design Name: 
// Module Name: MUX_4
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


module MUX_4 #(parameter DW=2)(
input wire [DW-1:0] A,B,C,D,SEL,
output reg [DW-1:0] OUT
    );
    
    always@(A,B,C,D,SEL) begin
        case(SEL)
            2'b00: OUT=A;
            2'b01: OUT=B;
            2'b10: OUT=C;
            2'b11: OUT=D;
            default: OUT=A;
        endcase
    end
    
endmodule
