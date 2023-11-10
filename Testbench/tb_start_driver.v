`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2023 16:57:20
// Design Name: 
// Module Name: tb_start_driver
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


module tb_start_driverM;

reg clk, rst, C_DB, SW_START;
wire RUN;

START_DRIVERM tbsd (.clk(clk),.rst(rst), .C_DB(C_DB), .SW_START(SW_START), .RUN(RUN));

always
#5 clk=~clk;

initial begin
    clk=1'b0;
    rst=1'b1;
    C_DB=1'b0;
    SW_START = 1'b0;
    #25 rst=1'b0;
    #25 C_DB=1'b1;
    #25 SW_START = 1'b1;
    #25 SW_START = 1'b0;
    #25 C_DB=1'b0;
    #25 SW_START = 1'b1;
    #25 SW_START = 1'b0;
    /*#50 C_DB=1'b1;
    #25 C_DB=1'b0;*/
    #100 $stop;
    
end

endmodule
