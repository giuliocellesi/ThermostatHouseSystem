`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2020 11:08:51
// Design Name: 
// Module Name: top_FIFO
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


module top_FIFO#(
parameter ADDR_WIDTH=2,
parameter DATA_WIDTH=8 
)( 
input wire ck,reset,insert,remove,flush, 
input wire [DATA_WIDTH-1:0] Win, 
output wire empty,full, 
output wire [DATA_WIDTH-1:0] Wout);


wire [ADDR_WIDTH-1:0] addr; 

dp #(.ADDR_WIDTH(ADDR_WIDTH)) u1(.ck(ck),.reset(reset),.clrWp(clrWp),.clrRp(clrRp),.incWp(incWp),.incRp(incRp),.RpNWp(RpNWp),.test(test),.addr(addr)); 
state_machine u2(.ck(ck),.reset(reset),.insert(insert),.remove(remove),.flush(flush),.test(test),.chipsel(chipsel),.write_en(write_en),.clrWp(clrWp),.clrRp(clrRp),.incWp(incWp), .incRp(incRp),.RpNWp(RpNWp),.empty(empty),.full(full)); 
ramParam #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) u3(.clk(ck),.chipsel(chipsel),.write_en(write_en),.address(addr),.data_in(Win),.data_out(Wout));


endmodule
