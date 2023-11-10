`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Usai Giovanni
// 
// Create Date: 24.05.2023 23:04:39
// Design Name: 
// Module Name: var_driver_selector
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


module var_driver_selector(
input wire clk, rst,
input wire hitAR, hitWSC, hitWSM, hitSS, hitST, hitOO, hitconfM,
input wire[3:0] out_A_R, out_WSC, out_WSM,out_SS, out_ST, out_ON_OFF, outconfM,
output reg[3:0] out
    );
/*4 (optCode) + id + ORA + MINUTI + TEMPERATURA*/
reg[3:0] out_nxt;
// Registro dell'OPCODE d'uscita
always@(posedge clk, posedge rst)begin
    if(rst == 1'b1) out <= {4{1'b0}};
    else out <= out_nxt; 
end

/*In base all' hit che si alza, assegna l'OPCODE ("out_nome") del segnale che ha variato*/
always@(hitAR, hitWSC, hitWSM,hitSS, hitST, hitOO, hitconfM, out,
        out_A_R, out_WSC, out_WSM,out_SS, out_ST, out_ON_OFF, outconfM)begin
casex({outconfM == 4'b1111, hitOO, hitAR, hitWSC, hitWSM, hitSS, hitST, hitconfM})
8'b1xxxxxxx: out_nxt = out;
8'b01xxxxxx :out_nxt = out_ON_OFF;
8'b001xxxxx: out_nxt = out_A_R;
8'b0001xxxx: out_nxt = out_WSC;
8'b00001xxx: out_nxt = out_WSM;
8'b000001xx: out_nxt = out_SS;
8'b0000001x: out_nxt = out_ST;
8'b00000001: out_nxt = outconfM;
default: out_nxt = out;
endcase
end

endmodule