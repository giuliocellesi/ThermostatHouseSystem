`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 20.05.2023 16:36:46
// Design Name: 
// Module Name: Slave_fifo
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

module Slave_fifo(
    input wire clk,rst,
    input wire o_RX_DV, empty,
    input wire [19:0] o_RX_BYTE,
    output wire i_TX_DV, remove, insert
    );
    
    wire mem,leg,clear;
    
    Fsm_slave FSM(.clk(clk),.rst(rst),.mem(mem),.leg(leg),.empty(empty),.clear(clear),.insert(insert),.remove(remove),.o_RX_DV(o_RX_DV));
    Dp_slave_fifo DP(.clk(clk),.rst(rst),.o_RX_DV(o_RX_DV),.o_RX_BYTE(o_RX_BYTE),.clear(clear),.remove(remove),.mem(mem),.leg(leg),.i_TX_DV(i_TX_DV));
    
endmodule
