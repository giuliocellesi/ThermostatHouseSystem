`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Are Emanuele, Mascia Lorenzo
// 
// Create Date: 30.05.2023 16:18:09
// Design Name: 
// Module Name: Master_buttons
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


module Master_buttons(
input wire clk, rst, start, restart,
input wire [1:0] windows,
output reg [3:0] data_to_send //dato che verrà poi inviato a spi master e inviati poi a Slave_buttons
);

always@(posedge clk, posedge rst)
if(rst) data_to_send <= 4'd0;
else data_to_send <= {start, restart, windows};

endmodule
