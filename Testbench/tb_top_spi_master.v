`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.05.2023 18:22:47
// Design Name: 
// Module Name: tb_top_spi_master
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


module tb_top_spi_master;
reg clk, rst;
reg rd;
reg [19:0] data_in; 
reg we, WS;
reg [4:0] DTF;
reg [5:0] RTR;
wire insert, read_end;
wire [19:0] RX_BYTE;
wire AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG,CW;

Top_spi_master_interface mod(clk, rst, rd, we, data_in, DTF, RTR, WS, read_end, insert, RX_BYTE, AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG,CW);

always 
#5 clk = ~clk;

initial
begin
clk = 1'b0; rst = 1'b1;
rd = 1'b0; we = 1'b0; data_in = 20'd5;
DTF = 5'd5; RTR = 6'd5; WS = 1'b0;
#10 rst = 1'b0;

#500 @(negedge clk) we=1'b1;
#20 @(negedge clk) we = 1'b0;

//scrittura in manor
#10000 @(negedge clk) data_in = 20'd6; we=1'b1;
#20 @(negedge clk) we = 1'b0;

//lettura
#20000 @(negedge clk) rd = 1'b1;
#5 @(negedge clk) rd = 1'b0;

//scritture
#10000 @(negedge clk) data_in = 20'd10; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd35; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd50; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd40; we=1'b1;
#20 @(negedge clk) we = 1'b0;

//scrittura mentre non ha finito la precedente, viene ignorata
#1500 @(negedge clk) data_in = 20'b11111101010101010101; we=1'b1;
#20 @(negedge clk) we = 1'b0;

//lettura
#20000 @(negedge clk) rd = 1'b1;
#5 @(negedge clk) rd = 1'b0;

#20000 @(negedge clk) data_in = 20'd100; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd111; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd222; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd333; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd444; we=1'b1;
#20 @(negedge clk) we = 1'b0;

#20000 @(negedge clk) data_in = 20'd555; we=1'b1;
#20 @(negedge clk) we = 1'b0;

//lettura
#20000 @(negedge clk) rd = 1'b1;
#5 @(negedge clk) rd = 1'b0;

#10000 $stop;

end
endmodule
