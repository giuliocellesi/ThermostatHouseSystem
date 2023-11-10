`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bergonzi Giuseppe
// 
// Create Date: 13.03.2023 15:11:08
// Design Name: 
// Module Name: timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: TIMER CON ENABLE NON PRESENTE NEL SISTEMA ORIGINARIO
// 
//////////////////////////////////////////////////////////////////////////////////


module contasec #(parameter stab=200, parameter t_base=99999)(
input wire clk, rst, enable, clr, //SE L'ENABLE è BASSO NON CONTINUA A CONTARE
output wire hit
    );
    
    reg [29:0] cnt, cnt_nxt;
    
    always@(cnt, enable)
    if(enable) begin
        if(cnt < stab*t_base) cnt_nxt = cnt + 30'd1; 
        else cnt_nxt = 30'd0;
    end
    else cnt_nxt = cnt;
    
    always@(posedge clk, posedge rst)
    if(rst) cnt <= 30'd0;
    else if(clr) cnt <= 30'd0;
    else cnt <= cnt_nxt;
    
    assign hit = (cnt == stab*t_base)? 1'b1:1'b0;
endmodule