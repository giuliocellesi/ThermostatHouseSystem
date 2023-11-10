`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Ilaria Nardi, Antonio Ledda, Ihab Teleb
// 
// Create Date: 21.03.2023 16:00:15
// Design Name:
// Module Name: FSM
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

module FSMM(
input wire clk,rst,
input wire RUN,WS,
input wire [2:0] DELTA,
output wire [1:0] LED,ID_WC,
output wire T_WC,
output reg CLR_WC
);

    reg [2:0] state,state_nxt;
    
    parameter OFF=3'b000,CALDO=3'b001,T_CALDO=3'b011,FREDDO=3'b100,T_FREDDO=3'b110;
    
    //state logic
    always@(posedge clk,posedge rst)
    if(rst==1'b1) state<=OFF;
    else state<=state_nxt;
    
    //state_nxt logic
    always@(state,RUN,WS,DELTA)
    case(state)
    OFF:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) state_nxt=CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) state_nxt=T_CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) state_nxt=FREDDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) state_nxt=T_FREDDO;
    else state_nxt=OFF;
    end
    CALDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) state_nxt=CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) state_nxt=T_CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) state_nxt=FREDDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) state_nxt=T_FREDDO;
    else state_nxt=OFF;
    end
    T_CALDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) state_nxt=CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) state_nxt=T_CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) state_nxt=FREDDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) state_nxt=T_FREDDO;
    else state_nxt=OFF;
    end
    FREDDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) state_nxt=CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) state_nxt=T_CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) state_nxt=FREDDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) state_nxt=T_FREDDO;
    else state_nxt=OFF;
    end
    T_FREDDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) state_nxt=CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) state_nxt=T_CALDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) state_nxt=FREDDO;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) state_nxt=T_FREDDO;
    else state_nxt=OFF;
    end
    default: state_nxt=OFF;
    endcase
    
    //Moore output logic
    reg [4:0] out;
    
    always@(state)
    case(state)
    OFF:
    out=5'b00000;
    CALDO:
    out=5'b01011;
    T_CALDO:
    out=5'b01010;
    FREDDO:
    out=5'b10111;
    T_FREDDO:
    out=5'b10110;
    default: out=5'b00000;
    endcase
    
    
    assign {LED,ID_WC,T_WC} = out;
    
    //Mealy output logic (CLR_WC)
    always@(state,RUN,WS,DELTA)
    case(state)
    OFF:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) CLR_WC=1'b1;
    else CLR_WC=1'b0;
    end
    CALDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) CLR_WC=1'b0;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) CLR_WC=1'b1;
    else CLR_WC=1'b1;
    end
    T_CALDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) CLR_WC=1'b0;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) CLR_WC=1'b1;
    else CLR_WC=1'b1;
    end
    FREDDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) CLR_WC=1'b0;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) CLR_WC=1'b1;
    else CLR_WC=1'b1;
    end
    T_FREDDO:
    begin
    if(RUN==1'b1 & WS==1'b1 & DELTA==3'b001) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b011) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b100) CLR_WC=1'b1;
    else if(RUN==1'b1 & WS==1'b1 & DELTA==3'b110) CLR_WC=1'b0;
    else CLR_WC=1'b1;
    end
    default: CLR_WC=1'b1;
    endcase

endmodule