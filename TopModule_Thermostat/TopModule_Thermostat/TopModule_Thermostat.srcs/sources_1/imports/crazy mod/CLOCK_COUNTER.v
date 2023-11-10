`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Paolo Galiano Bove
// 
// Create Date: 21.03.2023 16:23:52
// Design Name: 
// Module Name: CLOCK_COUNTER
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


module CLOCK_COUNTER #(parameter QTY=1, TU=100000000)( 
    //TU=Time_unit, unità di tempo, di default sta al secondo per la freq della Basys
    //QTY=Quantity, numero di (unità di tempo) da contare
    input wire clk, rst,
    output reg HIT
    );
    reg[$clog2((TU*QTY)-1):0] cnt, cnt_nxt; 
    
    always@(posedge clk, posedge rst)
    if(rst==1'b1) cnt <= {$clog2((TU*QTY)-1){1'b0}};
    else cnt <= cnt_nxt;
    
    always@(cnt) begin
        if(cnt < (TU*QTY)-1) begin
            cnt_nxt = cnt+1'b1;
            HIT = 1'b0;
        end else begin
            cnt_nxt = {$clog2((TU*QTY)-1){1'b0}};
            HIT = 1'b1;
        end
    end
endmodule
