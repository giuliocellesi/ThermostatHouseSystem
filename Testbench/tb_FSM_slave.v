`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2023 14:42:46
// Design Name: 
// Module Name: tb_FSM_slave
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


module tb_FSM_slave();

reg clk,rst,mem,leg,empty,o_RX_DV;
wire clear,insert,remove;
integer i;

Fsm_slave FSM(.clk(clk),.rst(rst),.mem(mem),.leg(leg),.empty(empty),.clear(clear),.insert(insert),.remove(remove),.o_RX_DV(o_RX_DV));

always
#5 clk = ~clk;

initial
begin
rst = 1'b1; clk = 1'b0; mem = 1'b0; leg = 1'b0; empty = 1'b0; o_RX_DV = 1'b0;
#50 rst = 1'b0;

//Testo tutte le combinazioni che non mandano nel prossimo stato la FSM (stato corrente: IDLE)

for(i = 0; i < 4; i = i + 1)begin

#10 @(negedge clk){empty,o_RX_DV} = i;

end

//Vado al prossimo stato (MEM)

#10 @(negedge clk){empty,o_RX_DV,mem} = 2'b001;
#10 @(negedge clk) mem = 1'b0;

//Testo tutte le combinazioni che non mandano nel prossimo stato la FSM (stato corrente: MEM)

for(i = 0; i < 8; i = i + 1)begin

#10 @(negedge clk){mem,leg,empty} = i;

end

//Vado in CLEAR

#10 @(negedge clk){mem,leg,empty,o_RX_DV} = 4'b0001;
#10 @(negedge clk) o_RX_DV = 1'b0;

//Vado in IDLE

#10;

//Vado in LEG

#10 @(negedge clk) leg = 1'b1;
#10 @(negedge clk) leg = 1'b0;

//Testo tutte le combinazioni che non mandano nel prossimo stato la FSM (stato corrente: LEG)

for(i = 0; i < 8; i = i + 1)begin

#10 @(negedge clk){mem,leg,o_RX_DV} = i;

end

//Torno in IDLE

#10 @(negedge clk){mem,leg,o_RX_DV,empty} = 5'b0001;
#10 @(negedge clk) empty = 1'b0;

#1000 $stop;
end
endmodule
