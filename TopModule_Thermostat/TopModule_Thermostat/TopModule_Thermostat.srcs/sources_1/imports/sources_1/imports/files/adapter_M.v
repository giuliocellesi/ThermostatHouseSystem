`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2021 09:31:13
// Design Name: 
// Module Name: modeAdapter
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


module adapter_M#(parameter SPI_MODE =3,
                    parameter MAX_EDGE_GEN = 16)( //cambiando questo decido il numero di bit da inviare
    input wire clk, rst,
    input wire in_r_edge, in_f_edge,
    input wire clear_d,
    output reg out_r_edge, out_f_edge,
    output wire last_edge
    );
  reg skipOne; //Settato a 1 dal primo fronte (salita o discesa) 
  reg[$clog2(MAX_EDGE_GEN):0] counterClkFronts;  //conteggio dei fronti di salita e discesa
  
  //In questa implementazione si ha sempre prima una trasmissione sulla linea MOSI.
  //Questo implica saltare (MODO 0 e MODO 2) il primo fronte che si incontra che darebbe luogo
  //ad un campionamento sulla linea MISO
  //Il salto viene abilitato attraverso l'uso di un registro che di default vale 0, e viene 
  //abilutato dal primo fronte
  always@(posedge clk, posedge rst)
  if (rst==1'b1) skipOne<=1'b0;
  else if (clear_d == 1'b1)
       skipOne<=1'b0;
  else if ((in_f_edge==1'b1 || in_r_edge==1'b1) && skipOne == 1'b0)
       skipOne<=1'b1; 
  
  //Per saltare l'eventuale campionamento prima della trasmissione 
  //MODO 0 - devo saltare il primo fronte di salita
  //MODO 2 - devo saltare il primo fronte di discesa 
  //Per i MODI 1 e 3 qundi i fronti da considerare sono tutti, per i MODI 0 e 2 solo quelli
  //che vengono individuati quando skipOne è stato settato (ossia dopo il primo fronte)  
  always@(posedge clk, posedge rst)
  if (rst==1'b1) 
  begin
    out_r_edge <= 1'b0;
    out_f_edge <= 1'b0;
  end
  else if (clear_d == 1'b1)
  begin
    out_r_edge <= 1'b0;
    out_f_edge <= 1'b0;
  end
  else if (SPI_MODE == 1 || SPI_MODE == 3 || skipOne == 1'b1)
  begin
    out_r_edge <= in_r_edge;
    out_f_edge <= in_f_edge;
  end 
  
  //In totale la SPI deve abilitare un numero di transazioni/ricezioni pari a due volte 
  //la dimensione totale del pacchetto (e.g. se ho pacchetti da 1 byte, serviranno 8 f_edge e 
  //8 r_edge per ricevere e spedire tutta l'informazione 
  //counterClkFronts conta i fronti
  //last_edge viene sollevato quando si arriva a 2*N, così da poter riportare la FSM in Idle
  always@(posedge clk, posedge rst)
  if (rst==1'b1) counterClkFronts<={$clog2(MAX_EDGE_GEN){1'b0}};
  else if (counterClkFronts == MAX_EDGE_GEN || clear_d == 1'b1)
       counterClkFronts<={$clog2(MAX_EDGE_GEN){1'b0}};
  else if (out_f_edge==1'b1 || out_r_edge==1'b1)
       counterClkFronts<=counterClkFronts+1;  
  
  assign last_edge = (counterClkFronts == MAX_EDGE_GEN)?1'b1:1'b0;
endmodule