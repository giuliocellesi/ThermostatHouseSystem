`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 20.05.2023 16:40:25
// Design Name: 
// Module Name: Dp_slave_fifo
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

//o_RX_DV <- Parola ricevuta valida
//i_TX_DV <- Parola caricata valida, essa lo sarà un colpo di clock in ritardo rispetto al segnale rem, si fa questo in modo che la parola risulti valida solo dopo che è stata rimossa dalla fifo (operazione che richiede 1 colpo di clock) 
//o_RX_BYTE <- Byte ricevuto
//clear <- clear per registro d_in
//remove <- Richiede rimozione dato dalla fifo
//insert <  Richiede inseimento dato alla fifo
//mem <- Richiede la memorizazzione di d_in su fifo
//leg <- Richiede la lettura di d_in su fifo
//d_in <- Dato da memorizzare su fifo

module Dp_slave_fifo(
    input wire clk,rst,
    input wire o_RX_DV,
    input wire [19:0] o_RX_BYTE,
    input wire clear,remove,
    output wire mem,leg,
    output wire i_TX_DV
    );
    reg [19:0] d_in;
    parameter MEM = 20'b11111111110000000000, LEG = 20'b00000000001111111111;
    reg reg_rem;
    
    assign mem = (d_in == MEM)? 1'b1 : 1'b0;
    assign leg = (d_in == LEG)? 1'b1 : 1'b0;
    assign i_TX_DV = reg_rem;
    
    always @(posedge clk, posedge rst)
      if(rst == 1'b1)reg_rem <= 1'b0;
       else reg_rem <= remove;
      
    always @(posedge clk, posedge rst)
      if(rst == 1'b1) d_in <= 20'd0;
        else if (clear == 1'b1) d_in <= 20'd0;
               else if (o_RX_DV == 1'b1) d_in <= o_RX_BYTE;
                
endmodule
