`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bergonzi Giuseppe, Usai Giovanni
// 
// Create Date: 26.05.2023 12:27:41
// Design Name: 
// Module Name: temp_hour
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


module temp_hour(
//input wire [3:0] OPCODE,
input wire clk,rst,
input wire [3:0] in_var,
input wire [5:0] RTRM,
input wire [5:0] RTRC,
input wire [2:0] h,
input wire [5:0] m,
input wire hitC, hitM,
output reg where,
output reg [3:0] OPCODE,
output reg [2:0] ora,
output reg[5:0] minuti,
output reg[5:0] RTRF
    );

reg where_n;
reg[3:0] OPCODE_n;
reg [2:0] ora_n;
reg[5:0] minuti_n;
reg[5:0] RTRF_n;

//REGISTRO DELLE USCITE
always@(posedge clk, posedge rst)begin
if(rst == 1'b1) {OPCODE, ora, minuti, where, RTRF} <= {20{1'b0}};
else{OPCODE, ora, minuti, where, RTRF} <= {OPCODE_n, ora_n, minuti_n, where_n, RTRF_n};
end
//Logica dei segnali
always@(in_var, RTRM, RTRC, h, m, hitC, hitM, OPCODE, ora, minuti, where, RTRF)begin
    //Se un segnale di Cellar o di Manor ha variato prendo tutti i segnali corrispondenti in ingresso
    //Caso separato per where e RTRF, che hanno bisogno di un controllo aggiuntivo se l'hit e di Cellar o 
    //di Manor, prendono L' RTRF corrispondente in ingresso.
    if(hitC == 1'b1 || hitM == 1'b1)begin
        ora_n = h;
        minuti_n = m;
        OPCODE_n = in_var;
        if(hitM == 1'b1) begin
            where_n = 1'b1;
            RTRF_n = RTRM;
        end else if(hitC == 1'b1) begin
            where_n = 1'b0;
            RTRF_n = RTRC;
        end else begin
            OPCODE_n = OPCODE;
            ora_n = ora;
            minuti_n = minuti;
            where_n = where;
            RTRF_n = RTRF;
        end
    end  
    else begin
            OPCODE_n = OPCODE;
            ora_n = ora;
            minuti_n = minuti;
            where_n = where;
            RTRF_n = RTRF;
    end
end
    
    
endmodule
