`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 24.05.2023 17:25:36
// Design Name: 
// Module Name: counter_std
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


module counter_std#(parameter SIZE = 8, parameter INC = 8'd1)(
input wire clk, rst, clear, enable, 
output reg [SIZE-1:0] cnt
    );
    
    reg [SIZE-1:0] cnt_nxt;
    wire [SIZE-1:0] out_mux_clear, out_mux_enable;
    
    //logica di incremento contatore
    always@(cnt)
    cnt_nxt = cnt + INC;
    
    //multiplexer per segnale di enable
    mux #(SIZE) mux_en(.i0(cnt), .i1(cnt_nxt), .sel(enable), .o(out_mux_enable));
    
    //multiplexer per segnale di clear
    mux #(SIZE) mux_clr(.i0(out_mux_enable), .i1({SIZE{1'b0}}), .sel(clear), .o(out_mux_clear));
    
    //registro di conteggio
    always@(posedge clk, posedge rst) 
    if(rst) cnt <= {SIZE{1'b0}};
    else cnt <= out_mux_clear;
    
endmodule

