`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni, Paolo Galiano Bove
// 
// Create Date: 21.03.2023 15:43:58
// Design Name: 
// Module Name: START_DRIVER
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


module START_DRIVERM(
input wire clk, rst, C_DB,SW_START,
output reg RUN
    );
    
    //piccola macchina a stati che appena riceve un segnale
    //aspetta un colpo di clk e poi tiene alta a 1 un uscita run
    //(per sempre, o almeno sino al rst che riporta in idle) 
    
    reg [1:0] state, state_nxt;
    
    parameter IDLE=2'b00, WAIT=2'b01, RUNNING=2'b10;
    
    always@(posedge clk, posedge rst) begin //registro di stato
        if(rst == 1'b1) state <= IDLE;
        else state <= state_nxt;
    end
    
    always@(state, C_DB, SW_START) begin //logica stato successivo
        case(state)
            IDLE: if(C_DB==1'b1) state_nxt = WAIT;
                    else state_nxt = IDLE;
            WAIT: if(SW_START==1'b1) state_nxt = RUNNING;
                    else state_nxt = WAIT;
            RUNNING: if(SW_START==1'b1) state_nxt = RUNNING;
                    else state_nxt = WAIT;
                    
            default : state_nxt = IDLE;
        endcase
    end
    
    always@(state) begin //logica uscita
        case(state)
            IDLE: RUN =1'b0;
            WAIT: RUN =1'b0;
            RUNNING: RUN =1'b1;
            default RUN =1'b0;
        endcase
    end
    
    
endmodule
