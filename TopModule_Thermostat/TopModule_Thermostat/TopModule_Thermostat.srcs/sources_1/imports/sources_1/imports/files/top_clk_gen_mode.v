`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.04.2022 19:12:01
// Design Name: 
// Module Name: top_gen_clk
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


module top_clk_gen_mode#(
            parameter SPI_MODE = 3,//modalità di trasmissione
            parameter SPI_CLK_DIVIDER = 8, //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz         
            parameter DATA_SIZE = 8
)
(
input wire clk, rst,
input wire idle_v,
input wire en_oclk, clear_d,
output wire o_SPI_Clk,
output wire enableRX, enableTX,
output wire last_edge
    );

parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2; 
parameter MAX_EDGE_GEN = DATA_SIZE*2; //EDGES salita/discesa totali
wire r_edge_modeAdapter,f_edge_modeAdapter;

//generatore del clock SPI
//genero fronti di salita e di disceda ___|---|___
clk_gen_M #(.SPI_MODE(SPI_MODE),.HALF_BIT_NUM(CLKS_PER_HALF_BIT))
C_GEN(.clk(clk), .rst(rst), .o_clk(o_SPI_Clk),.r_edge(r_edge_modeAdapter),
.f_edge(f_edge_modeAdapter),.en_oclk(en_oclk), .idle_v(idle_v));
   
//adattatore dei modi: consente di saltare un fronte (salita/discesa) per evitare "prima" il campionamento che la trasmissione
adapter_M #(.SPI_MODE(SPI_MODE),.MAX_EDGE_GEN(MAX_EDGE_GEN))
M_AD(.clk(clk), .rst(rst),.in_r_edge(r_edge_modeAdapter),.in_f_edge(f_edge_modeAdapter), 
.clear_d(clear_d),.out_r_edge(r_edge),.out_f_edge(f_edge), .last_edge(last_edge));

//generazione dei segnali di enable per trasmissione e campionamento
 assign enableRX = (((SPI_MODE == 0 || SPI_MODE == 3) && r_edge == 1) ||
                    ((SPI_MODE == 1 || SPI_MODE == 2) && f_edge == 1)) ? 1'b1:1'b0;
                    
 assign enableTX = (((SPI_MODE == 0 || SPI_MODE == 3) && f_edge == 1) ||
                    ((SPI_MODE == 1 || SPI_MODE == 2) && r_edge == 1)) ? 1'b1:1'b0;


endmodule