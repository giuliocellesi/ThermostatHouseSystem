`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Antonio Ledda, Ilaria Nardi
// 
// Create Date: 23.03.2023 15:06:16
// Design Name: 
// Module Name: TEST_BENCH_WINDOWS_OPEN_DRIVER
// Project Name: Thermostat_control_system
// Target Devices: Basys3
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


module TEST_BENCH_WINDOWS_OPEN_DRIVERC();
reg clk,rst;
reg active;
reg [5:0] ETR,RTR;
wire CLR;
wire[1:0] LED;
wire T_WO;
wire [2:0] ID_WO;


WINDOWS_OPEN_DRIVERC wop(.clk(clk),.rst(rst), .active(active),.ETR(ETR),.RTR(RTR),.CLR(CLR), .LED(LED), .T_WO(T_WO),.ID_WO(ID_WO));

always #5 clk=~clk;

initial
begin
clk=1'b0;
rst=1'b1;
ETR=6'd25;
RTR=6'd25;
active = 1'b0;

#13 rst=1'b0;

#100 @(negedge clk) ETR=6'd0;

#100 @(negedge clk) ETR=6'd10;

#100 @(negedge clk) ETR=6'd20;

#100 @(negedge clk) ETR=6'd40;

#100 @(negedge clk) ETR=6'd20;

#100 @(negedge clk) active = 1'b1;

#200 @(negedge clk) active = 1'b0;

#10 $stop;

end
endmodule
