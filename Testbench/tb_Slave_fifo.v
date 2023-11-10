`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2023 16:09:27
// Design Name: 
// Module Name: tb_Slave_fifo
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


module tb_Slave_fifo();

reg clk,rst;
reg o_RX_DV;
reg [19:0] o_RX_Byte;
wire i_TX_DV;
wire [19:0] i_TX_Byte;

top_slave_fifo SLAVE(.clk(clk), .rst(rst), .o_RX_DV(o_RX_DV), .i_TX_DV(i_TX_DV), .o_RX_Byte(o_RX_Byte), .i_TX_Byte(i_TX_Byte));

always
#5 clk = ~clk;

initial
begin
rst = 1'b1; clk = 1'b0; o_RX_DV = 1'b0; o_RX_Byte = 20'd0;
#50 rst = 1'b0;

//Faccio due scritture nella FIFO

#50 @(negedge clk) o_RX_Byte = 20'b11111111110000000000; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

#50 @(negedge clk) o_RX_Byte = 20'b10100010011101011011; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

#50 @(negedge clk) o_RX_Byte = 20'b11111111110000000000; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

#50 @(negedge clk) o_RX_Byte = 20'b10100111011101011011; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

//Faccio altre due scritture dove scrivo il MEM e il LEG per verificare se la richiesta di memorizazzione di combinazioni di dati sensibili come queste possono dare probelmi

#50 @(negedge clk) o_RX_Byte = 20'b11111111110000000000; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

#50 @(negedge clk) o_RX_Byte = 20'b11111111110000000000; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

#50 @(negedge clk) o_RX_Byte = 20'b11111111110000000000; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

#50 @(negedge clk) o_RX_Byte = 20'b00000000001111111111; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

//Leggo tutto dalle fifo

#50 @(negedge clk) o_RX_Byte = 20'b00000000001111111111; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;
#50 @(negedge clk) o_RX_Byte = 20'b11111111111111111111; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;
#50 @(negedge clk) o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;
#50 @(negedge clk) o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;
#50 @(negedge clk) o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0;

//Il sistema ignorerà qualsiasi dato se prima non viene mandato il MEM

#50 @(negedge clk) o_RX_Byte = 20'b000010101010101111110; o_RX_DV = 1'b1;
#10 @(negedge clk) o_RX_DV = 1'b0; 

#1000 $stop;

end
endmodule
