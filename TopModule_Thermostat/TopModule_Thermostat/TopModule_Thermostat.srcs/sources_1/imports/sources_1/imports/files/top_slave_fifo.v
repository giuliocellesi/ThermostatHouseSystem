`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 23.05.2023 09:59:57
// Design Name: 
// Module Name: top_slave_fifo
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


module top_slave_fifo#(parameter SIZE_FIFO=5)(
    input wire clk,rst,
    input wire o_RX_DV, //segnale proveniente da spi slave che indica che il dato è stato ricevuto
    input wire [19:0] o_RX_Byte, //parola ricevuta da linea MOSI
    output wire i_TX_DV, //segnale per abilitare invio di nuovo dato su linea MISO
    output wire [19:0] i_TX_Byte //Segnale da trasmettere su linea MISO
    );
    
    wire empty,remove,insert;
    
    Slave_fifo SLAVE_FIFO(.clk(clk), .rst(rst), .o_RX_DV(o_RX_DV), .empty(empty), .o_RX_BYTE(o_RX_Byte), .i_TX_DV(i_TX_DV), .remove(remove), .insert(insert));
    top_FIFO#(.ADDR_WIDTH(SIZE_FIFO),.DATA_WIDTH(20)) FIFO(.ck(clk), .reset(rst), .insert(insert), .remove(remove), .flush(1'b0), .full(), .Win(o_RX_Byte), .empty(empty), .Wout(i_TX_Byte));
    
endmodule
