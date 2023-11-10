`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 22.03.2023 16:55:41
// Design Name: 
// Module Name: COUNTER
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


module COUNTER_SS(
input wire clk, rst, INCR_DB_R, DECR_DB_R,
input wire [4:0] DTM,
output reg [4:0] DTF
    );
    
    reg [4:0] DTF_nxt;
    
    always@(posedge clk, posedge rst) begin //registro per DTF
        if(rst==1'b1) DTF <= 5'b00000;
        else DTF <= DTF_nxt;
    end
    
    always@(DTM,INCR_DB_R, DECR_DB_R) begin //logica aggiornamento valore successivo
        case(DTM)
            5'b00000: begin
                if(INCR_DB_R == 1'b1) DTF_nxt = DTM + 5'b00001;
                else DTF_nxt = DTM;
            end
            5'b11111: begin
                if(DECR_DB_R == 1'b1) DTF_nxt = DTM - 5'b00001;
                else DTF_nxt = DTM;
            end
            default: begin
                if(INCR_DB_R == 1'b1) DTF_nxt = DTM + 5'b00001;
                else if(DECR_DB_R == 1'b1) DTF_nxt = DTM - 5'b00001;
                else DTF_nxt = DTM;            
            end
        endcase
    end
    
endmodule
