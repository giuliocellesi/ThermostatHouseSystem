`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Paolo Galiano, Alessandro Monni
// 
// Create Date: 21.03.2023 15:46:42
// Design Name: 
// Module Name: DELTA_T_DRIVER
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


module DELTA_T_DRIVER(
input wire [5:0] RTR,
input wire [4:0] DTF,
output reg [2:0] DELTA
    );
    
    parameter CALDO=3'b001, T_CALDO=3'b011, FREDDO=3'b100, T_FREDDO=3'b110, RANGE=3'b000;
    
    wire signed [6:0] DIFF; //questo segnale è con il segno (signed) e ha bisogno di un bit in più
    assign DIFF = $signed( RTR - {1'b0, DTF} ); //tutte le operazioni devono essere fatte con la notazione $signed
    
    
    always@(RTR,DTF,DIFF) begin //anche i confronti devono essere fatti con la notazione $signed
        if      ($signed(DIFF > 7'sd1) && $signed(DIFF < 7'sd6)     ) DELTA = FREDDO;       //[2:5]
        else if ($signed(DIFF > 7'sd5)                              ) DELTA = T_FREDDO;     //[6:inf)
        else if ($signed(DIFF < -7'sd1) && $signed(DIFF > -7'sd6)   ) DELTA = CALDO;        //[-5:-2]
        else if ($signed(DIFF < -7'sd5)                             ) DELTA = T_CALDO;      //(-inf:-6]
        else                                                          DELTA = RANGE;        //[-1:1]
    end
      
endmodule