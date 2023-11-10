`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 21.03.2023 15:25:41
// Design Name: 
// Module Name: REG
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


module REG #(parameter DW=1)(
input wire clk, rst,en, wire [DW-1:0] D,
output reg [DW-1:0] Q
    );
    
    always@(posedge clk, posedge rst) begin
        if(rst==1'b1) Q <= {DW{1'b0}};
        else if(en==1'b1)Q <= D ;
    end   
    
endmodule
