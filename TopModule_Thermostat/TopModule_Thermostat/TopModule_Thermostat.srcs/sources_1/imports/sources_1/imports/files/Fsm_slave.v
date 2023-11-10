`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 20.05.2023 16:37:59
// Design Name: 
// Module Name: Fsm_slave
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

//mem -> Richiede la memorizzazione del dato provveniente dalla SPI Slave
//leg -> Richiede la lettura dalla fifo di tutti i dati presenti in essa
//empty -> Notifica che la fifo è vuota
//clear -> svuota il registro reg_d_in
//insert -> Richiede inserimento dato presente in o_RX_Byte dell'SPI slave nella fifo
//remove -> Richiede rimozione dato dalla fifo

module Fsm_slave(
    input wire clk,rst,
    input wire mem,leg,empty,o_RX_DV,
    output reg clear,insert,remove
    );
    
    parameter IDLE = 2'b00, LEG = 2'b01, MEM = 2'b10, CLEAR = 2'b11;
    reg [1:0] state,state_nxt;
    
    always @(posedge clk, posedge rst)
    if (rst==1'b1) state <= IDLE;
    else state <= state_nxt;
    
    //Stato successivo
    always@(state,mem,leg,empty,o_RX_DV)
    case(state)
     IDLE:  if (leg==1'b1) state_nxt = LEG;
            else if(mem == 1'b1) state_nxt = MEM;
                else state_nxt = IDLE;
     LEG:  if (empty == 1'b1) state_nxt = IDLE;
           else state_nxt = LEG;
     MEM:  if(o_RX_DV == 1'b1) state_nxt = CLEAR;
           else state_nxt = MEM;
     CLEAR:  state_nxt = IDLE;
     default:  state_nxt = IDLE;
    endcase
    
    //Uscite di Moore
    always @(state)
    case(state)
     IDLE: clear = 1'b0;
     LEG: clear = 1'b0;
     MEM: clear = 1'b0;
     CLEAR: clear = 1'b1;
     default: clear = 1'b0;
    endcase
    
    //Uscite di Mealy
    always@(state,mem,leg,empty,o_RX_DV)
    case(state)
     IDLE: if(leg == 1'b1) {insert,remove} = 2'b01;
           else {insert,remove} = 2'b00;
     LEG: if(o_RX_DV == 1'b1 && empty == 1'b0) {insert,remove} = 2'b01;
          else {insert,remove} = 2'b00;
     MEM: if(o_RX_DV == 1'b1) {insert,remove} = 2'b10;     
          else {insert,remove} = 2'b00;
     CLEAR: {insert,remove} = 2'b00;
     default: {insert,remove} = 2'b00;  
    endcase
endmodule
