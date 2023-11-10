`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 20.05.2023 19:28:32
// Design Name: 
// Module Name: Master_fifo_display
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


module Master_fifo_display #(parameter SIZE_FIFO=5)(
input wire clk, rst,
input wire tx_ready, /*In input dalla spi master*/
input wire rd, we, wire [19:0] data_in, /*In input da sistema termostato*/
input wire [4:0] DTF, wire [5:0] RTR, wire WS, /*In input per il display*/
output wire read_end, insert, /*wire [19:0] RX_BYTE,*/ /*In uscita per fifo di appoggio e (read_end) per log screen*/
output wire [19:0] data_to_send, wire [1:0] ss /*In output per la spi master*/
    );
    wire [1:0]ss_f; wire en_cr1, en_cr2, hitr1, hitr2, clear, en_cw;
    wire [1:0] sel;
    
    wire we_fin;
    assign we_fin = (data_in[19:5] == 5'd0)? 1'b0 : we; //Scriviamo quando i primi 5 bit più significativi in arrivo dal System Core sono diversi da 0
    
    Fsm_master_fifo FSM(.clk(clk), .rst(rst), .rd(rd), .we(we_fin), .tx_ready(tx_ready), .hitr1(hitr1), .hitr2(hitr2), .ss_f(ss_f), .en_cr1(en_cr1), .en_cr2(en_cr2), .en_cw(en_cw), .clear(clear), .sel(sel), .read_end(read_end));
    
    Dp_master_fifo #(.SIZE_FIFO(SIZE_FIFO)) DATA_PATH(.clk(clk), .rst(rst), .ss_f(ss_f), .en_cr1(en_cr1), .en_cr2(en_cr2), .en_cw(en_cw), .clear(clear), .sel(sel), .data_in(data_in), .we(we_fin), .DTF(DTF), .RTR(RTR), .WS(WS), .o_RX_DV(tx_ready), .read_end(read_end), .ss(ss), .data_to_send(data_to_send), .hitr1(hitr1), .hitr2(hitr2), .insert(insert));
endmodule
