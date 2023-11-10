`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Usai Giovanni
// 
// Create Date: 23.05.2023 21:12:36
// Design Name: 
// Module Name: VAR_DRIVER
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


module VAR_DRIVER(
input wire clk, rst,
input wire run,
    input wire start,
    input wire confM,
    input wire al, wsc, wsm,ss, st,
    
    output reg hitC_var, hitM_var,
    output wire[3:0] out_var
);
//Parametri usati per l'assegnazione dell'OPCODE nelle fsm
parameter STOP = 4'b0101, START = 4'b0100, AL_ON = 4'b0000, AL_REST = 4'b0001, WS_OPEN = 4'b0010, WS_CLOSE = 4'b0011, SUMMER = 4'b0110, WINTER = 4'b0111, DAY = 4'b1000, NIGHT = 4'b1001, CONFM = 4'b1010;
wire hit_A_R, hit_WSC, hit_WSM,hit_SS, hit_ST, hit_ON_OFF, hit_confM;
wire[3:0] out_A_R, out_WSC, out_WSM,out_SS, out_ST, out_ON_OFF, out_confM;
reg hitC_nxt, hitM_nxt;

// Macchina a stati per ogni segnale d'ingresso 
fsmVAR#(.ID_1(START),      .ID_2(STOP))     fsm_stt_stp(.clk(clk), .rst(rst), .start(run), .in(start), .hit(hit_ON_OFF), .out(out_ON_OFF));
fsmVAR#(.ID_1(AL_ON), .ID_2(AL_REST))       fsm_al_rest(.clk(clk), .rst(rst), .start(run), .in(al), .hit(hit_A_R), .out(out_A_R));
fsmVAR#(.ID_1(WS_CLOSE),   .ID_2(WS_OPEN))  fsm_wsC(.clk(clk), .rst(rst), .start(run), .in(wsc), .hit(hit_WSC), .out(out_WSC));
fsmVAR#(.ID_1(WS_CLOSE),   .ID_2(WS_OPEN))  fsm_wsM(.clk(clk), .rst(rst), .start(run), .in(wsm), .hit(hit_WSM), .out(out_WSM));
fsmVAR#(.ID_1(SUMMER),     .ID_2(WINTER))   fsm_ss(.clk(clk), .rst(rst), .start(run), .in(ss), .hit(hit_SS), .out(out_SS));
fsmVAR#(.ID_1(DAY),        .ID_2(NIGHT))    fsm_st(.clk(clk), .rst(rst), .start(run), .in(st), .hit(hit_ST), .out(out_ST));
fsmCONF fsm_cnfm(.clk(clk), .rst(rst), .start(1'b1), .in(confM), .hit(hit_confM), .out(out_confM));

var_driver_selector var_driver_select(.clk(clk),.rst(rst), .hitAR(hit_A_R), .hitWSC(hit_WSC), .hitWSM(hit_WSM),.hitSS(hit_SS), .hitST(hit_ST), .hitOO(hit_ON_OFF), .hitconfM(hit_confM),
                                      .out_A_R(out_A_R), .out_WSC(out_WSC), .out_WSM(out_WSM),.out_SS(out_SS), .out_ST(out_ST), .out_ON_OFF(out_ON_OFF), .outconfM(out_confM),
                                      .out(out_var));

//Registro degli hit delle variazioni dei segnali di Cellar e Manor
always@(posedge clk, posedge rst)begin
if(rst == 1'b1) begin
hitC_var <= 1'b0;
hitM_var <= 1'b0;
end else begin
hitC_var <= hitC_nxt;
hitM_var <= hitM_nxt;
end
end

// Logica per gli hit dei segnali di Cellar e Manor
// In base alla variazione degli hit, attivo l'hit di Cellar o di Manor                     
always@(hit_A_R, hit_WSC, hit_WSM, hit_ON_OFF, hit_SS, hit_ST, hit_confM)begin
if(hit_A_R | hit_WSC) hitC_nxt = 1'b1;
else hitC_nxt = 1'b0;
if(hit_WSM | hit_ON_OFF | hit_SS | hit_ST | hit_confM) hitM_nxt = 1'b1;
else hitM_nxt = 1'b0;
end

endmodule