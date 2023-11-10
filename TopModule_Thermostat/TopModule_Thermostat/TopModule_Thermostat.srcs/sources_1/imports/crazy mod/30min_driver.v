`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Miccio Carlo
// 
// Create Date: 17.05.2023 16:06:14
// Design Name: 
// Module Name: 30min_driver
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


module time_driver(
input wire RUN,
input wire [4:0] DTF,
input wire [5:0] RTR,//CONFRONTA SEMPRE LE TEMPERATURE E ALZA L'ENABLE SE SI SUPERA IL RANGE DESIDERATO
output reg en
    );
     wire signed [6:0] DIFF; //questo segnale è con il segno (signed) e ha bisogno di un bit in più
    assign DIFF = $signed( RTR - {1'b0, DTF} ); //tutte le operazioni devono essere fatte con la notazione $signed

    always@(DTF,RTR,RUN, DIFF)
    if (RUN)
    if($signed(DIFF < -7'sd3) || ($signed(DIFF > 7'sd3) ) ) en=1'b1;
    else en=1'b0;
    else en=1'b0;
endmodule
