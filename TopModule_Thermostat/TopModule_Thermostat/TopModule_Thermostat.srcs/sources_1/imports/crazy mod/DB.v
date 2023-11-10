`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 21.03.2023 15:22:40
// Design Name: 
// Module Name: DB
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


module DB #(parameter QTY=200, TU=999999)(
input wire clk, rst, S,
output wire SDB
    );
    parameter IDLE=2'b00, HIGH=2'b01, WAIT=2'b10;
    reg [1:0] state, state_nxt;
    
    CLOCK_COUNTER #(QTY,TU) cc(.clk(clk), .rst(rst), .HIT(HIT));
    
    
    
    always@(posedge clk, posedge rst) begin //registro di stato
        if(rst==1'b1) state <= IDLE;
        else state <= state_nxt;
    end
    
    always@(state, S, HIT) begin //logica stato successivo
        case(state)
            IDLE: begin
                if(S==1'b0) state_nxt=IDLE;
                else state_nxt=HIGH;
            end
            HIGH: state_nxt=WAIT;
            WAIT: begin
                if(HIT==1'b1 || S==1'b0) state_nxt=IDLE; //torniamo in idle (pronto a ricevere un nuovo input)
                                                        //se è passato il tempo o se smettiamo di premere il tasto
                else state_nxt=WAIT; 
            end
            default: state_nxt=IDLE;        
        endcase
    end
    
    assign SDB=state[0]; //logica uscita
    
    
endmodule
