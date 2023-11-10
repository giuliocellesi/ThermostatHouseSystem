`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1 
// Engineer: Paolo Galiano Bove, Antonio Ledda, Alessandro Monni, Ilaria Nardi, Ihab Teleb 
// 
// Create Date: 23.03.2023 17:21:52
// Design Name: 
// Module Name: TOP_MODULE
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


module TOP_MODULE_CELLAR(
input wire clk,rst,
input wire DECR,INCR,restart,
input wire CONF,SS,ST,nWS,
input wire [4:0] DT,
output wire WS,
output wire [4:0]DTF,
output wire [5:0]RTR,
output wire[1:0] LED,
output wire active,
output wire RUN
);


wire DECR_DB,restart_DB,INCR_DB,C_DB,T_WC,CLR_WC,CLR_WO,T_WO,TIME,CLR,HIT;
wire [1:0] ID_WC,LED_O,LED_C;
wire [2:0] DELTA,ID_WO,ID;
wire [4:0] DTR;
wire [5:0] ET,ETR;
assign WS=~nWS;

top_alarm allarme(.clk(clk),.rst(rst),.RUN(RUN),.restart(restart),.ws(WS),.CLR_WC(CLR_WC),.DTF(DTF),.RTR(RTR),.active(active));

 //PER SCHEDA:  .QTY(200), .TU(1000000), PER DB = .QTY(2), .TU(10)
DB #(.QTY(200), .TU(1000000)) dbr(.clk(clk),.rst(rst),.S(restart),.SDB(restart_DB));

DB #(.QTY(200), .TU(1000000)) dbd(.clk(clk),.rst(rst),.S(DECR),.SDB(DECR_DB));

DB #(.QTY(200), .TU(1000000)) dbi(.clk(clk),.rst(rst),.S(INCR),.SDB(INCR_DB));

REG #(.DW(5)) reg_dt(.clk(clk),.rst(rst),.en(C_DB),.D(DT),.Q(DTR));

DB #(.QTY(200), .TU(1000000)) dbc(.clk(clk),.rst(rst),.S(CONF),.SDB(C_DB));

START_DRIVERC start_driver(.clk(clk),.rst(rst),.C_DB(C_DB),.RUN(RUN));

SUB_SUM_DRIVER ssd(.clk(clk),.rst(rst),.RUN(RUN),.INCR_DB(INCR_DB),.DECR_DB(DECR_DB),.DTR(DTR),.DTF(DTF));

DELTA_T_DRIVER dtd(.RTR(RTR),.DTF(DTF),.DELTA(DELTA)); 

//SEVEN_SEG_DRIVER ssdr(.clk(clk),.rst(rst),.WS(WS),.DTF(DTF),.RTR(RTR),.AN0(AN0),.AN1(AN1),.AN2(AN2),.AN3(AN3),.CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG),.CW(CW));

fsm_modified fsm(.clk(clk),.rst(rst),.active(active),.RUN(RUN),.WS(WS),.DELTA(DELTA),.LED(LED_C),.ID_WC(ID_WC),.T_WC(T_WC),.CLR_WC(CLR_WC));

//LED_DRIVER ld(.clk(clk),.rst(rst),.LED(LED),.LED_OUT(LED_OUT));

REG #(.DW(6))reg_et(.clk(clk),.rst(rst),.en(1'b1),.D(ET),.Q(ETR));

WINDOWS_OPEN_DRIVERC wos(.clk(clk),.rst(rst),.active(active),.ETR(ETR),.RTR(RTR),.CLR(CLR_WO),.T_WO(T_WO),.ID_WO(ID_WO),.LED(LED_O));

// SE SI VUOLE TESTARE SU SCHEDA SI CONSIGLIA DI CAMBIARE I PARAMETRI QTY E TU DEL TIMER
// CHE RAPPRESENTANO IL MASSIMO NUMERO DI -UNIT� DI TEMPO- DA DOVER ASPETTARE
// (NOI LO METTIAMO A 2 MINUTI (120 SECONDI) COME DA SPECIFICA).
// SI CONSIGLIA DI INSERIRE I SEGUENTI PARAMETRI QTY=10 TU=100000000
// QUESTI PARAMETRI IMPOSTANO IL TIMER AD UN CONTEGGIO MASSIMO DI 10 SECONDI
// (AUTOMATICAMENTE IL TIMER CONTER� IN BASE AI SEGNALI DI INPUT IL "CONTEGGIO MASSIMO" OPPURE LA SUA MET�)
// PRECISIAMO ANCORA CHE NELLA SPECIFICA QUESTI PARAMETRI SONO 2 MINUTI (120 SECONDI) E 1 MINUTO (CHE � LA SUA MET�))

// PER SCHEDA: .QTY(10), .TU(34'd100000000) PER TB: .QTY(2), .TU(34'd10) 
TIMER #(.QTY(120), .TU(34'd100000000)) tmp(.clk(clk),.rst(rst),.CLEAR(CLR),.TIME(TIME),.HIT(HIT));

RT_DRIVER rt_driver(.clk(clk),.rst(rst),.HIT(HIT),.ID(ID),.RTR(RTR)); 

MUX_2 #(.DW(1)) mux_t(.A(T_WO),.B(T_WC),.SEL(WS),.OUT(TIME));

MUX_2 #(.DW(3)) mux_id(.A(ID_WO),.B({ID_WC,1'b0}),.SEL(WS),.OUT(ID));

MUX_2 #(.DW(1)) mux_clr(.A(CLR_WO),.B(CLR_WC),.SEL(WS),.OUT(CLR));

MUX_4 #(.DW(6)) mux_et(.A(6'd0),.B(6'd10),.C(6'd20),.D(6'd40),.SEL({4'b0000,SS,ST}),.OUT(ET));    

MUX_2 #(.DW(2)) mux_led(.A(LED_O),.B(LED_C),.SEL(WS),.OUT(LED)); //led accensione

endmodule

