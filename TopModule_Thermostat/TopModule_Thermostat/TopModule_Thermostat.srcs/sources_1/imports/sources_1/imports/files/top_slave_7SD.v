`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 23.05.2023 11:05:05
// Design Name: 
// Module Name: top_slave_7SD
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


module top_slave_7SD(
    input wire clk,rst,
    input wire o_RX_DV,
    input wire [19:0] o_RX_BYTE,
    output wire AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG,CW
    );
    
    wire WS;
    wire [4:0] DTF;
    wire [5:0] RTR;
    
    Slave_7SD SLAVE_7SD(.clk(clk), .rst(rst), .o_RX_DV(o_RX_DV), .o_RX_BYTE(o_RX_BYTE), .WS(WS), .DTF(DTF), .RTR(RTR));
    SEVEN_SEG_DRIVER SEVENSD(.clk(clk), .rst(rst), .WS(WS), .DTF(DTF), .RTR(RTR), .AN0(AN0), .AN1(AN1), .AN2(AN2), .AN3(AN3), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .CW(CW)); 
     
endmodule
