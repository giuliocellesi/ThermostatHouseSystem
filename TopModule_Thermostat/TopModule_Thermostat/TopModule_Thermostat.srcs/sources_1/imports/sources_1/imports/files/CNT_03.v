`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 23.03.2023 15:17:33
// Design Name: 
// Module Name: CNT_03
// Project Name: Thermostat Control Driver
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


module CNT_03(
input wire clk,rst,HIT,
output wire [1:0] SEL
    );
    
    reg[1:0] state, state_nxt;
    
    parameter ZERO=2'b00, UNO=2'b01, DUE=2'b10, TRE=2'b11;
    
    //piccola macchina a stati che conta 0 1 2 3 ciclicamente
    
    always@(posedge clk, posedge rst)
        if(rst==1'b1) state <= 2'b00;
        else state <= state_nxt;
    
    always@(state,HIT) //logica stato successivo
        case(state)
            ZERO: if(HIT==1'b1) state_nxt = UNO;
                    else state_nxt = state;
            UNO: if(HIT==1'b1) state_nxt = DUE;
                    else state_nxt = state;
            DUE: if(HIT==1'b1) state_nxt = TRE;
                    else state_nxt = state;
            TRE: if(HIT==1'b1) state_nxt = ZERO;
                    else state_nxt = state;
            default: state_nxt = ZERO;
        endcase
        
    assign SEL = state; //logica uscita
    
endmodule
