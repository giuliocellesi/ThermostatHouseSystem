`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2023 19:17:43
// Design Name: 
// Module Name: tb_selector
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


module tb_selector;

reg clk,rst;
reg DECR,INCR;
reg CONF, ID_SW;
reg [4:0] DT;
wire DECR_MAN,INCR_MAN, DECR_CEL, INCR_CEL,
 CONF_MAN, CONF_CEL;
wire [4:0] DT_MAN, DT_CEL;

SELECTOR_SYST_CORE sele(.clk(clk), .rst(rst), .DECR(DECR), .INCR(INCR), .CONF(CONF), .ID_SW(ID_SW),
.DT(DT), .DECR_MAN(DECR_MAN), .INCR_MAN(INCR_MAN), .DECR_CEL(DECR_CEL), .INCR_CEL(INCR_CEL), .CONF_MAN(CONF_MAN), .CONF_CEL(CONF_CEL), 
.DT_MAN(DT_MAN), .DT_CEL(DT_CEL));

always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
DECR = 1'b0;
INCR = 1'b0;
CONF = 1'b0;
ID_SW = 1'b0;
DT = 4'b1001;

#8 rst = 1'b0;
#10 INCR = 1'b1; 
#10 INCR = 1'b0; 

#30 DECR = 1'b1;
#10 DECR = 1'b0;

#30 CONF = 1'b1;
#10 CONF = 1'b0;

#40 ID_SW = 1'b1;
#10 INCR = 1'b1; 
#10 INCR = 1'b0; 

#30 DECR = 1'b1;
#10 DECR = 1'b0;

#30 CONF = 1'b1;
#10 CONF = 1'b0;

#50 DT = 4'b0101;
#25 ID_SW = 1'b0;
#15 $stop;
end

endmodule
