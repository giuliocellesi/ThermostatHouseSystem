`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Cellesi Giulio
// 
// Create Date: 16.05.2023 14:58:03
// Design Name: 
// Module Name: TopModule
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


module Top_log_screen #(parameter ADDR_WIDTH=4,
                             DATA_WIDTH=248,
                             CH_WIDTH=8, //character width
                             DATA_BW=8, DATA_BW_BIT=4, 
                             BAUD_RATE=9600,
                             BAUD_COUNT=10416, //with BAUD_RATE 9600bps and system clk 100MHz --> baud rate counter is 10416 represented with N_BIT=14
                             BAUD_BIT=14    
)(
input wire clk, rst, start, empty_FIFO,
input wire [19:0] data_in, //data from system core to master
output wire consume,
output wire TX
);

parameter DEPTH=(2**ADDR_WIDTH);

wire inc; //increment the index
wire send; //enable the transmit in the UART
wire available; //available of the UART
wire update;
wire done; //indicates that all the message has been sent
wire [CH_WIDTH-1:0] character;
wire hit;
wire en_timer;

timer_param #(3) TIMER_AUX(clk, rst, en_timer, hit);

GetCharacter #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH), .CH_WIDTH(CH_WIDTH))
    GetC(.clk(clk), .rst(rst), .data_in(data_in), .update(update), .inc(inc), .done(done), .character(character));
fsm_logScreenConnection FSM(.clk(clk), .rst(rst), .start(start), .stop(empty_FIFO), .update(update), .done(done), .en_timer(en_timer),
    .hit(hit), .available(available), .consume(consume), .inc(inc), .send(send));
top_tx #(.DATA_BW(DATA_BW),.DATA_BW_BIT(DATA_BW_BIT),.BAUD_RATE(BAUD_RATE),.BAUD_COUNT(BAUD_COUNT), .BAUD_BIT(BAUD_BIT)) 
    DUT(.clk(clk), .rst(rst), .transmit(send),.data_in(character), .TX(TX), .available(available));


endmodule
