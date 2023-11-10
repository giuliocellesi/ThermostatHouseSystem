`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bergonzi Giuseppe
// 
// Create Date: 16.05.2023 22:18:26
// Design Name: 
// Module Name: orologio
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


module orologio #(
parameter
SX_MAX=6,
DX_MAX=60
)
(
input wire clk,rst,en,
output reg  [$clog2(SX_MAX)-1:0] ora,
output reg [$clog2(DX_MAX)-1:0] minuti,
output reg done//alto quando l'ora arriva al valore di SX_MAX
    );
    reg [$clog2(SX_MAX)-1:0] ora_nxt;
    reg [$clog2(DX_MAX)-1:0] min_nxt;
    reg cap;
    wire hit;
    
always@(posedge clk,posedge rst)
if (rst) ora<={($clog2(SX_MAX)-1){1'b0}};
else ora<=ora_nxt;

always@(posedge clk,posedge rst)
if (rst) minuti<={($clog2(DX_MAX)-1){1'b0}};
else minuti<=min_nxt;

//logica dei minuti
always@(hit,cap, minuti)
if (cap) min_nxt={($clog2(DX_MAX)-1){1'b0}};
else
if (hit)  min_nxt=minuti+1;
else min_nxt=minuti; 

//logica delle ore
always@(cap,done, ora)
if (done) ora_nxt={($clog2(SX_MAX)-1){1'b0}};
else begin
    if (cap) ora_nxt=ora+3'd1;
    else ora_nxt=ora;
end

//logica per incremento delle ore ogni 60 minuti
always@(minuti,hit,done)
if (done) cap=1'b0;
else begin
    if (hit)begin
        if (minuti==DX_MAX) cap=1'b1;
        else cap=1'b0;
    end
    else cap = 1'b0;
end

//logica del done
always@(ora)
if (ora==SX_MAX) done=1'b1;
else done=1'b0;

/*PER TB: .stab(1),.t_base(50)*/
contasec #(.stab(10),.t_base(9999999))  timer(.clk(clk),.rst(rst),.hit(hit),.clr(done),.enable(en));

endmodule








