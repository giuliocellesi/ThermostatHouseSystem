`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Cellesi Giulio
// 
// Create Date: 20.05.2023 13:24:01
// Design Name: 
// Module Name: timer_param
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


module timer_param #(parameter LIMIT = 30'd10)(
input wire clk, rst, enable,
output wire timeout
    );
    
parameter BIT = $clog2(LIMIT);

reg [BIT-1:0] cnt, cnt_next;

always @ (posedge clk, posedge rst)
if (rst == 1'b1) cnt <= {BIT{1'b0}};
else cnt <= cnt_next;

always @ (cnt, enable)
if (enable == 1'b1)
    begin
     if (cnt < LIMIT) cnt_next = cnt + {{BIT-1{1'b0}}, 1'b1};
     else cnt_next = {BIT{1'b0}};
    end
else 
cnt_next = {BIT{1'b0}};

assign timeout = (cnt == LIMIT) ? 1'b1 : 1'b0;

endmodule
