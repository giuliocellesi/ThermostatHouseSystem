`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Miccio Carlo, Bergonzi Giuseppe
// 
// Create Date: 17.05.2023 00:35:33
// Design Name: 
// Module Name: top_alarm
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

//INPUT:FINESTRA,CLEAR,RUN(SISTEMA IN FUNZIONE SE ALTO),TEMPERATURA DESIDERATA E CORRENTE)
module top_alarm(
input wire clk,rst,restart,ws,CLR_WC,RUN,
input wire [4:0] DTF,
input wire [5:0] RTR,
output wire active//ALLARME ON/OFF
    );
    
    wire en;
    wire ent,hit;
    
    time_driver DUT(.DTF(DTF),.RTR(RTR),.RUN(RUN),.en(en));
    alarm_driver fsm_alarm(.clk(clk),.rst(rst),.hit(hit),.active(active),.ent(ent),.en(en),.restart(restart),.ws(ws));
    //stab = 1800 -> per comportamento reale ; stab = 10 per prova 
    contasec #(.stab(1800),.t_base(34'd99999999)) timer(.clk(clk),.rst(rst),.enable(ent),.clr(CLR_WC),.hit(hit));
endmodule
