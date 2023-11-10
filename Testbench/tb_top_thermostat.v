`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.06.2023 16:12:17
// Design Name: 
// Module Name: tb_top_thermostat
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


module tb_top_thermostat;
reg clk, rst;
reg DECR, INCR, CONF, SW_START, SS, ST, WS_MANOR, WS_CELLAR;
reg ID_SW, RESTART;
reg [4:0] DT;
//wire AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG,CW;
wire TX;
wire[15:0] LED_OUT;
integer i;

Top_Thermostat TOP_TH(.clk(clk), .rst(rst), .DECR(DECR), .INCR(INCR), .CONF(CONF), .SW_START(SW_START), .SS(SS),
                               .ST(ST), .WS_MANOR(WS_MANOR), .WS_CELLAR(WS_CELLAR), .ID_SW(ID_SW), .RESTART(RESTART), .DT(DT),
                               //.AN0(AN0), .AN1(AN1), .AN2(AN2), .AN3(AN3), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .CW(CW),
                               .TX(TX), .LED_OUT(LED_OUT));
                               
always 
#5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
DECR = 1'b0;
INCR = 1'b0;
CONF = 1'b0;
SW_START = 1'b0;
SS = 1'b0;
ST = 1'b0;
WS_MANOR = 1'b0;
WS_CELLAR = 1'b0;
ID_SW = 1'b0;
RESTART = 1'b0;
DT = 5'b10111;

#100 rst = 1'b0;

// Configurazione Cellar di conseguenza parte anche il timer 
#100 @(negedge clk) CONF = 1'b1;
#1000 @(negedge clk) CONF = 1'b0;   

// Cambio stanza (Manor)
#100 @(negedge clk) ID_SW = 1'b1;

// Configuro Manor
#100 @(negedge clk) CONF = 1'b1;
#1000 @(negedge clk) CONF = 1'b0;

// Avvio Manor 
#5100 @(negedge clk) SW_START = 1'b1;

// Apro finestra Manor e cambio stagione 
#5100 @(negedge clk) WS_MANOR = 1'b1;

#5100 @(negedge clk) SS = 1'b1; 
#5100 @(negedge clk) SS = 1'b0; //cambio temperatura di riferimento per non far scattare l'allarme data la finestra aperta


// Chiudo finestra Manor faccio lo stesso ma con finestra chiusa 
#5100 @(negedge clk) WS_MANOR = 1'b0;

#5100 @(negedge clk) SS = 1'b1;
#5100 @(negedge clk) SS = 1'b0; //cambio temperatura di riferimento per non far scattare l'allarme data la finestra aperta

// Cambio stanza (Cellar)
#100 @(negedge clk) ID_SW = 1'b0;

// Apro finestra Cellar e cambio stagione 
#5100 @(negedge clk) WS_CELLAR = 1'b1;

#5100 @(negedge clk) SS = 1'b1;
#5100 @(negedge clk) SS = 1'b0;

// Chiudo finestra Cellar e cambio stagione
#5100 @(negedge clk) WS_CELLAR = 1'b0;

#5100 @(negedge clk) SS = 1'b1;
#5100 @(negedge clk) SS = 1'b0;

// Cambio giorno notte 
#5100 @(negedge clk) ST = 1'b1;
#5100 @(negedge clk) ST = 1'b0;

// Imposto temperatura di riferimetno minima a 0 per generare active (vado in ALARM)
for(i = 0; i < 23; i = i + 1)begin 
#100 @(negedge clk) DECR = 1'b1;
#100 @(negedge clk) DECR = 1'b0;
end

#20000 // Attendo allarm

// Torno alla temperatura originaria di riferimento per non andare in ALARM di nuovo quando alzo il RESTART
for(i = 0; i < 18; i = i + 1)begin 
#100 @(negedge clk) INCR = 1'b1;
#100 @(negedge clk) INCR = 1'b0;
end

#5100 RESTART = 1'b1;
#5100 RESTART = 1'b0;


#15000 $stop;

end                 
endmodule
