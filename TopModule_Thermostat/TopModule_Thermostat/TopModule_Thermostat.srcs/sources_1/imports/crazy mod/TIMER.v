`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Ilaria Nardi, Paolo Galiano Bove, Antonio Ledda
// 
// Create Date: 21.03.2023 16:00:15
// Design Name:
// Module Name: TIMER
// Project Name: Thermostat_control_system
// Target Devices: Basys3
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

module TIMER #(
parameter 
QTY=20,             //Quantity, numero di (unità di tempo) da contare
TU=34'd100000000    //Time_unit, unità di tempo, di default sta al secondo per la freq della Basys
)( 
input wire clk, rst,
input wire CLEAR,TIME,
output reg HIT
);
    
reg[$clog2((TU*QTY)-1):0] cnt, cnt_nxt; 
    
//state logic
always@(posedge clk, posedge rst)
if(rst==1'b1) cnt<={$clog2((TU*QTY)-1){1'b0}};
else cnt<=cnt_nxt;
    
//count_nxt logic
always@(cnt,CLEAR)
if(cnt<((TU*QTY)-1) & CLEAR==1'b0) cnt_nxt=cnt+1;
else cnt_nxt={$clog2((TU*QTY)-1){1'b0}};

//HIT logic si alza solo a x e a x*2 secondi
always@(cnt, TIME)
if((cnt==((TU*QTY/2)-1) | cnt==((TU*QTY)-1)) & TIME==1'b0) HIT=1'b1; //se sono passati 60 secondi
else if(cnt==((TU*QTY)-1) & TIME==1'b1) HIT=1'b1; //se sono passati 120 secondi
else HIT=1'b0;

endmodule