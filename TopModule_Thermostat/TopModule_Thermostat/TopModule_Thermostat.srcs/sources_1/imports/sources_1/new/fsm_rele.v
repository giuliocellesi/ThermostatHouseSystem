`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo
// 
// Create Date: 08.06.2023 11:29:11
// Design Name: 
// Module Name: fsm_rele
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


module fsm_rele(
input wire clk, rst,
input wire en, clr,
output reg out
    );
    parameter IDLE = 1'b0, ACTIVE = 1'b1;
    reg state, state_nxt;
    
    //logica stato successivo
    always@(state, en, clr)
    case(state)
    IDLE: if(en && !clr) state_nxt = ACTIVE; else state_nxt = IDLE; //Se il segnale da tenere alto arriva (e non arriva in contemporanea il clear)
    ACTIVE: if(clr) state_nxt = IDLE; else state_nxt = ACTIVE; //se arriva il clear torno ad abassare il segnale mantenuto alto
    default: state_nxt = state;
    endcase
    
    //registro stato
    always@(posedge clk, posedge rst)
    if(rst) state <= IDLE;
    else state = state_nxt;
    
    //logica uscite di Moore
    always@(state)
    if(state == IDLE) out = 1'b0;
    else out = 1'b1;
endmodule
