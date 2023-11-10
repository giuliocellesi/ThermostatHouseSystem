`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Miccio Carlo, Bergonzi Giuseppe
// 
// Create Date: 16.05.2023 23:28:12
// Design Name: 
// Module Name: alarm_driver
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


module alarm_driver (
input wire clk,rst,en,restart,hit,ws, //HIT ALTO SE RAGGIUNTI I 30 MINUTI
output reg active,ent//SEGNALE D'ALLARME E ENABKE TIMER CHE SI ALZA NELLO STATO COUNTING
    );
    parameter IDLE=2'd0,COUNTING=2'd1,ALARM=2'd2;
    reg [1:0] state,state_nxt;
    
    always@(posedge clk,posedge rst)
    if(rst) state<=IDLE;
    else state<=state_nxt;
    
    always@(state,en,hit,restart, ws)
    case (state)
    IDLE: 
    if (en) state_nxt=COUNTING;
    else state_nxt=IDLE;
    COUNTING:
    if(hit) state_nxt=ALARM;
    else if(en) state_nxt=COUNTING;
    else state_nxt=IDLE;    
    ALARM:
    if(restart && (ws==1'b1)) state_nxt=IDLE;
    else state_nxt=ALARM;
    default:state_nxt=IDLE;
    endcase
    
    always@(state)
    case (state)
    IDLE: begin
    active=1'b0;
    ent=1'b0;
    end
    COUNTING:begin
    active=1'b0;
    ent=1'b1;
    end
    ALARM: begin
    active=1'b1;
    ent=1'b0;
    end
    default :
    begin 
    active=1'b0;ent=1'b0;
    end
    endcase
    
endmodule
