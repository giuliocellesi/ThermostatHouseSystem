`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2022 19:48:58
// Design Name: 
// Module Name: clk_gen_M
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


module clk_gen_M #(parameter SPI_MODE =0,
                 parameter HALF_BIT_NUM = 2 //numero di bit per semi-periodo
                )(
    input wire clk, rst,
    input wire idle_v, en_oclk,
    output reg r_edge, f_edge,   
    output  reg  o_clk
    );
    
reg [$clog2(HALF_BIT_NUM*2)-1:0] counter , counter_nxt;

/*contatore che opera la divisione della frequenza di funzionamento*/
always @(posedge clk, posedge rst)
if (rst=='b1) counter<={$clog2(HALF_BIT_NUM*2){1'b0}};
else counter<=counter_nxt;

always@(counter,en_oclk)
if (en_oclk==1'b0) counter_nxt={$clog2(HALF_BIT_NUM*2){1'b0}}; //conteggio fermo fino a che non arriva l'abilitazione dalla FSM
else if (counter>=HALF_BIT_NUM*2-1) counter_nxt={$clog2(HALF_BIT_NUM*2){1'b0}};
          else  counter_nxt= counter + 1; 


//identificazione di tutti i fronti di salita e di discesa
always @(posedge clk, posedge rst)
if (rst=='b1)
begin
    f_edge<=1'b0;
    r_edge<=1'b0;
end
else if (idle_v == 0) // idle value of SCLK = 0 --> MODO 0 o 1
begin
    if (counter==HALF_BIT_NUM-1) 
    begin 
        r_edge<=1'b1;
        f_edge<=1'b0;
    end
    else if (counter==HALF_BIT_NUM*2-1)
    begin 
        r_edge<=1'b0;
        f_edge<=1'b1;
    end
    else
    begin 
        r_edge<=1'b0;
        f_edge<=1'b0;
    end
end    
else // idle value of SCLK = 1 --> MODO 2 o 3
begin
    if (counter==HALF_BIT_NUM-1) 
    begin 
        r_edge<=1'b0;
        f_edge<=1'b1;
    end
    else if (counter==HALF_BIT_NUM*2-1)
    begin 
        r_edge<=1'b1;
        f_edge<=1'b0;
    end
    else
    begin 
        r_edge<=1'b0;
        f_edge<=1'b0;
    end
end

//generazione del clock di trasmissione   
always @(posedge clk, posedge rst)
if(rst==1'b1) o_clk <= idle_v;
else if (en_oclk==1'b0) o_clk <= idle_v;
     else if (f_edge==1'b1 || r_edge==1'b1) o_clk <= ~o_clk;
     
endmodule
