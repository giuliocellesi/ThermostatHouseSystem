`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Paolo Galiano Bove, Alessandro Monni
// 
// Create Date: 23.03.2023 14:47:50
// Design Name: 
// Module Name: SEVEN_SEG_DRIVER
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


module SEVEN_SEG_DRIVER(
input  wire clk,rst,WS,
input  wire [4:0] DTF,
input  wire [5:0] RTR,
output wire AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG, 
output reg CW
    );
    
    wire HIT;
    wire[1:0] SEL;
    wire [4:0] SEG,SEG0,SEG1,SEG2,SEG3;

    CLOCK_COUNTER #(.QTY(5),.TU(100000)) clock_counter(.clk(clk),.rst(rst),.HIT(HIT)); //classico clock counter per il refresh dello schermo
    
    DIGIT_DECODER digit_decoder_RTR(.TO_CONVERT(RTR),.D(SEG1),.U(SEG0)); //decoder per convertire da binario a due cifre decimali
    
    DIGIT_DECODER digit_decoder_DTR(.TO_CONVERT({1'b0,DTF}),.D(SEG3),.U(SEG2)); //decoder per convertire da binario a due cifre decimali
    
    CNT_03 cnt03(.clk(clk),.rst(rst),.HIT(HIT),.SEL(SEL)); //contatore ciclico per il refresh di una delle quattro cifre in base a HIT di clock_counter
    
    MUX_4 #(.DW(5)) mux_seg (.SEL({3'b000,SEL}),.A(SEG0),.B(SEG1),.C(SEG2),.D(SEG3),.OUT(SEG)); //aggiornamento di un segmento in base a SEL 
    
    ANODE_DECODER anodec(.SEL(SEL),.AN0(AN0),.AN1(AN1),.AN2(AN2),.AN3(AN3)); //aggiornamento di un segmento in base a SEL
    
    CATODE_DECODER catode_decoder (.SEG(SEG),.CA(CA),.CB(CB),.CC(CC),.CD(CD),.CE(CE),.CF(CF),.CG(CG)); //decoder dei catodi del segmento presa una cifra
    
    always@(WS,SEL) begin //logica accensione puntino seconda cifra per finestre aperte
        if(WS==1'b0 && SEL==2'b01) CW=1'b0;
        else CW=1'b1;
    end   
        
endmodule