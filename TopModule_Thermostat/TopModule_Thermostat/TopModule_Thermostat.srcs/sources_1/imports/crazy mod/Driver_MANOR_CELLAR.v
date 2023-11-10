`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Usai Giovanni
// 
// Create Date: 18.05.2023 16:45:32
// Design Name: 
// Module Name: Driver_MANOR_CELLAR
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


module Driver_MANOR_CELLAR #(parameter SIZE_IN = 8)(
input wire[SIZE_IN-1:0] in,
output reg DECR,INCR, CONF,
output reg [4:0] DT
);

always@(in)begin
DECR = in[7];
INCR = in[6];
CONF = in[5];
DT = {in[4], in[3], in[2], in[1], in[0]}; 
end


endmodule
