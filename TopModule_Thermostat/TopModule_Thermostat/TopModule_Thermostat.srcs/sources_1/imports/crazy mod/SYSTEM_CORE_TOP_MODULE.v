`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Miccio Carlo, Usai Giovanni, Bergonzi Giuseppe
// 
// Create Date: 18.05.2023 15:23:50
// Design Name: 
// Module Name: SYSTEM_CORE_TOP_MODULE
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


module SYSTEM_CORE_TOP_MODULE(
input wire clk,rst,
input wire DECR,INCR,
input wire CONF,SW_START,SS,ST,WS_MANOR, WS_CELLAR, 
input wire ID_SW, RESTART, //INPUT NUOVI
input wire [4:0] DT,
output wire hit_write,
output wire hit_read,
output wire WS,
output wire [4:0] DTF,
output wire [5:0] RTR,
output wire[15:0] LED_OUT,
output wire[19:0] DATA
);

wire DECR_MAN,INCR_MAN, DECR_CEL, INCR_CEL;
wire CONF_MAN, CONF_CEL;
wire [4:0] DTF_MANOR, DTF_CELLAR,DT_CELLAR,DT_MANOR;
wire [5:0] RTR_M,RTR_C;
//wire AN0M,AN1M,AN2M,AN3M,CAM,CBM,CCM,CDM,CEM,CFM,CGM,CWM,AN0C,AN1C,AN2C,AN3C,CAC,CBC,CCC,CDC,CEC,CFC,CGC,CWC;
wire[1:0]LEDC,LEDM,LEDF;
 //wire [1:0] LED_MANOR, LED_CELLAR;
 //wire [4:0] DTF_MANOR,DTF_CELLAR;
 //wire [5:0] RTR_MANOR,RTR_CELLAR;
wire nWS,nWSM,al_out;
wire [11:0]out;
wire [2:0] ora;
wire [5:0] minuti;

wire hitC_var, hitM_var, where;
wire [3:0] OPCODE;
wire [2:0] oraF;
wire [5:0] minutiF,currentT;
wire[3:0] out_var;
wire RUN;
temp_hour tempo_temperatura(.clk(clk),.rst(rst), .in_var(out_var), .h(ora),.m(minuti),.RTRM(RTR_M),.RTRC(RTR_C),.hitC(hitC_var), .hitM(hitM_var), .OPCODE(OPCODE),.where(where),.ora(oraF),.minuti(minutiF),.RTRF(currentT));

VAR_DRIVER variazioni_segnali(.clk(clk),.rst(rst), .run(RUN),.start(SW_START), .confM(CONF_MAN),.ss(SS), .st(ST),
                  .wsc(nWS),.wsm(nWSM),.al(al_out),.hitC_var(hitC_var), .hitM_var(hitM_var), .out_var(out_var));

wire needRead;

fsm_rele MOD_NEEDREAD(.clk(clk), .rst(rst), .en(hit_write), .clr(hit_read), .out(needRead));

wire hit_needRead;
assign hit_read = hit_needRead && needRead; //Per far si che la richiesta di lettura avvenga solo quando c'è stato almeno un cambiamento

//i parametri dell'orologio corrispondono alle ore massime che si vogliono contare e ai minuti
orologio#(.SX_MAX(6),.DX_MAX(60)) time_scan(.clk(clk),.rst(rst),.en(RUN),.ora(ora),.minuti(minuti),.done(hit_needRead)); 

SELECTOR_SYST_CORE select_disp(.clk(clk), .rst(rst), .DECR(DECR), .INCR(INCR), .CONF(CONF), .ID_SW(ID_SW),
                 .DT(DT), .DECR_MAN(DECR_MAN), .INCR_MAN(INCR_MAN), .DECR_CEL(DECR_CEL), .INCR_CEL(INCR_CEL), 
                 .CONF_MAN(CONF_MAN), .CONF_CEL(CONF_CEL), .DT_MAN(DT_MANOR), .DT_CEL(DT_CELLAR));

DISPLAY_LED_DRIVER selectled(.clk(clk), .rst(rst),.LEDC(LEDC),.LEDM(LEDM),.LEDF(LEDF),.nWSM(nWSM),.nWSC(nWS),
.DTF_CELLAR(DTF_CELLAR),.DTF_MANOR(DTF_MANOR),.RTR_MANOR(RTR_M),.RTR_CELLAR(RTR_C),.ID_SW(ID_SW),.out(out));

TOP_MODULE_MANOR M_TOP(.clk(clk), .rst(rst), .nWSM(WS_MANOR),.DECR(DECR_MAN), .INCR(INCR_MAN), .CONF(CONF_MAN), .SW_START(SW_START),
.SS(SS), .ST(ST), .DT(DT_MANOR), .DTF(DTF_MANOR),.RTR(RTR_M),.nWS(nWSM),.LED(LEDM));

TOP_MODULE_CELLAR C_TOP(.clk(clk), .rst(rst), .restart(RESTART),.nWS(WS_CELLAR), .DECR(DECR_CEL), .INCR(INCR_CEL), .CONF(CONF_CEL),
.SS(SS), .ST(ST), .DT(DT_CELLAR),.DTF(DTF_CELLAR),.RTR(RTR_C),.WS(nWS),.LED(LEDC),.active(al_out), .RUN(RUN));

LED_DRIVER ld(.clk(clk),.rst(rst),.LED(LEDF),.LED_OUT(LED_OUT));

// WS, RTR, DTF, Prendono i segnali dei bit di out provenienti da DISPLAY LED DRIVER
assign WS = out[0];
assign RTR = out[6:1];
assign DTF = out[11:7];
//DATA contiene il messaggio che viene mandato per l'SPI
assign DATA = {OPCODE, !where, oraF, minutiF, currentT};
//Si alza al segnale alto degli hit delle variazioni di Cellaro o di manor o entrambi.
assign hit_write = hitC_var | hitM_var;
endmodule