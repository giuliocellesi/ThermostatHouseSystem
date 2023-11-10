`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 20.05.2023 18:12:29
// Design Name: 
// Module Name: Selector_master_fifo
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


module Selector_master_fifo(
input wire [19:0] data_in, segi, leg, mem,
input wire [1:0] sel, wire ss_f,
output reg [19:0] d_out
    );
    
    //sulla base del valore di sel si seleziona un dato da inviare piuttosto che un altro
    always@(sel, ss_f, data_in, segi, leg, mem)
    casex({ss_f, sel})
    3'b0xx : d_out = segi; //se ss_f è a 0 vuol dire che ho selezionato il display a 7 segmenti, quindi a prescindere trasmetto i segi
    3'b101 : d_out = data_in;
    3'b110 : d_out = leg;
    3'b111 : d_out = mem;
    default : d_out = 20'd0;
    endcase
endmodule
