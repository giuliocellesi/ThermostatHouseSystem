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

module modeAdapterS#(
    parameter SPI_MODE =3,
    parameter DATA_SIZE=8
    )(
    input wire clk, rst,
    input wire SPI_clk_M, 
    input wire [$clog2(DATA_SIZE)-1:0] TX_cnt,
    input wire [$clog2(DATA_SIZE)-1:0] RX_cnt,
    input wire idle_v,
    input wire enableTX,
    output reg enable_CHRX,
    output reg disable_CHTX,
    output reg r_edge,
    output reg f_edge
    );
  
  reg reg_SPI_clk_S; //SPI clock interno sfasato
  
  /*Per identificare tutti i fronti di salita e discesa del SPI clock viene definito 
  un SPI clock sfasato (reg_SPI_clk_S) di un colpo di clock di sistema rispetto a quello 
  generato dal master*/
  always@(posedge clk, posedge rst)
  if (rst==1'b1) reg_SPI_clk_S <= idle_v;
  else reg_SPI_clk_S <= SPI_clk_M;

  /*Comparando il clock SPI del master e quello sfasato è possibile determinare quali sono 
  i fronti di salita e di discesa*/
  always@(posedge clk, posedge rst)
  if (rst==1'b1) begin
    r_edge <= 1'b0;
    f_edge <= 1'b0;
  end
  else if(reg_SPI_clk_S == 0 && SPI_clk_M == 1) begin
    r_edge <= 1'b1;
    f_edge <= 1'b0;
  end
  else if(reg_SPI_clk_S == 1 && SPI_clk_M == 0) begin
    r_edge <= 1'b0;
    f_edge <= 1'b1;
  end
  else begin
    r_edge <= 1'b0;
    f_edge <= 1'b0;
  end
   
  /*
  Per i MODI 1 e 3 i fronti da considerare sono tutti: canale di ricezione sempre abilitato
  Nel master per i MODI 0 e 2: devo saltare il primo fronte di salita/discesa per evitare 
  trasmissione prima di campionamento
  Lato slave:
  - disabilito la ricezione quando il downcounter dei dati ricevuti è al suo massimo (RX_cnt == 3'd7)
  - riabilito la ricezione quando il downcounter dei dati trasmessi ha superato il massimo (TX_cnt == 3'd7)
  */ 
  always@(posedge clk, posedge rst)
  if (rst==1'b1) enable_CHRX<=1'b0;
  else if (SPI_MODE == 1 || SPI_MODE == 3) enable_CHRX <= 1'b1;
        else if (TX_cnt == DATA_SIZE-2) enable_CHRX<=1'b1;
             else if (RX_cnt == DATA_SIZE-1) enable_CHRX<=1'b0; 
  
  /*
  Per i MODI 1 e 3: canale di trasmissione sempre abilitato
  Nel master per i MODI 0 e 2: devo saltare il primo fronte di salita/discesa per evitare 
  trasmissione prima di campionamento. Però per completare il campionamento di tutti i dati 
  si è reso necessario prolungare l'abilitazione del clock SPI, a causa dello sfasamento 
  iniziale che fa iniziare il campionamento dopo la prima trasmissione.
  Lato slave questo ha un effetto di creare un fronte di discesa(MODE 0)/salita(MODE 2) in più,
  consegientemente per eviare una trasmissione non voluta:
  - disabilito la trasmissione quando il downcounter dei dati ricevuti è al suo minimo, 
    ma a valle della trasmissione (RX_cnt == 3'd0 && enableTX)
  - riabilito la trasmissione quando il downcounter dei dati ricevuti è al suo massimo, 
    ma a valle della trasmissione non voluta(RX_cnt == 3'd7 && enableTX)
  */ 
  always@(posedge clk, posedge rst)
  if (rst==1'b1) disable_CHTX<=1'b0;
  else if (SPI_MODE == 1 || SPI_MODE == 3) disable_CHTX <= 1'b0;
  else if (RX_cnt == 0 && enableTX) disable_CHTX<=1'b1;
  else if (RX_cnt == DATA_SIZE-1 && enableTX) disable_CHTX<=1'b0; 
  
endmodule
