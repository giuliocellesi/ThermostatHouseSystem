`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 10.06.2023 16:00:26
// Design Name: 
// Module Name: Comms_Dispatcher
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


module Comms_Dispatcher#(parameter SIZE_FIFO = 5)(
input wire clk, rst,
//input relativi a master fifo-display
input wire rd, we, wire [19:0] data_in, /*In inut da sistema termostato*/
input wire [4:0] DTF, wire [5:0] RTR, wire WS, /*In input per il display*/
input wire tx_ready, //Dato da spi master per master fifo display
//input relativi a slave bottoni
input wire arrived, 
input wire [3:0] data_received, 
//input relativi a log_screen per FIFO
input wire consume,
input wire [19:0] data_to_FIFO,
//output relativi a master fifo display
output wire read_end,/*In uscita per fifo di appoggio*/
output wire [19:0] data_to_send, //Dato che andrà all'spi master verso fifo-7sd
output wire [1:0] ss,
//output relativi a slave bottoni
output wire start_out, restart_out, 
output wire [1:0] windows_out,
//output FIFO
output wire empty_FIFO,
output wire [19:0] data_to_UART
    );
    
    wire we_r, rd_r, insert;
    fsm_rele WRITE_EN_RELE(.clk(clk), .rst(rst), .en(we), .clr(tx_ready), .out(we_r));
    fsm_rele READ_EN_RELE(.clk(clk), .rst(rst), .en(rd), .clr(tx_ready), .out(rd_r));
    
    //Master verso fifo e display
    Master_fifo_display #(.SIZE_FIFO(SIZE_FIFO))MASTER_FIFO_DISPLAY(.clk(clk), .rst(rst), .rd(rd_r), .we(we_r), .data_in(data_in), .DTF(DTF), .RTR(RTR), .WS(WS), 
    .tx_ready(tx_ready), .read_end(read_end), .insert(insert), .data_to_send(data_to_send), .ss(ss)); 
    
    //slave che riceve da master bottoni
    Slave_buttons S(.clk(clk),.rst(rst), .o_RX_DV(arrived), .data(data_received), .data_stored({start_out, restart_out, windows_out}));
    
    top_FIFO #(.ADDR_WIDTH(SIZE_FIFO),.DATA_WIDTH(20)) fifo_auxiliary(.ck(clk), .reset(rst), .insert(insert), .Win(data_to_FIFO), .empty(empty_FIFO), .flush(1'b0),.full(),.remove(consume), .Wout(data_to_UART));
endmodule
