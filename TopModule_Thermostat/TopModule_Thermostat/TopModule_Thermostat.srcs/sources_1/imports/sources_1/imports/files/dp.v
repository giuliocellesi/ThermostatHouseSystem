`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2020 14:14:46
// Design Name: 
// Module Name: dp
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


module dp#(
parameter ADDR_WIDTH=2
)(
input wire ck,reset,
input wire clrWp,clrRp,
input wire incWp,incRp,
input wire RpNWp, 
output wire test, 
output wire [ADDR_WIDTH-1:0] addr);


//--------------Internal signals---------------- 
wire [ADDR_WIDTH-1:0] Wp;
wire [ADDR_WIDTH-1:0] Rp; 

ptr_mng #(.ADDR_WIDTH(ADDR_WIDTH)) WP(.clk(ck), .rst(reset),.incr(incWp), .clear(clrWp),.ptr(Wp));
ptr_mng #(.ADDR_WIDTH(ADDR_WIDTH)) RP(.clk(ck), .rst(reset),.incr(incRp), .clear(clrRp),.ptr(Rp));
mux #(.N(ADDR_WIDTH)) M(.i0(Wp),.i1(Rp),.sel(RpNWp),.o(addr));

assign test = (Wp==Rp) ? 1'b1 : 1'b0; 

endmodule 

