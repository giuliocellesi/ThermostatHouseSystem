`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2021 10:33:13
// Design Name: 
// Module Name: SPI_master
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


module SPI_master #(parameter SPI_MODE = 3,                         //modalità di trasmissione
                    parameter SPI_CLK_DIVIDER = 8,                  //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2, //SPI_CLK_DIVIDER/2
                    parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2, //EDGES to be generated
                    parameter DATA_SIZE = 8
                    )(
                    
                    input wire clk, rst, //segnali globali di controllo
                    
                    input wire [1:0] slave_selector, 
                    
                    /*interfaccia MOSI verso il produttore (Per ricevere dati da produttore che poi invia a Slave)*/
                    // i_TX_Byte --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [DATA_SIZE-1:0]  i_TX_Byte,        
                    // i_TX_DV --> Se alto il byte ricevuto è valido
                    input wire        i_TX_DV, //viene dal produttore per dire che i_TX_Byte è ok
                    //  o_TX_Ready --> 1: .'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere al consumatore          
                    output wire       o_TX_Ready, //Per dire al produttore che posson prendere altro byte (ho completato trasmissione a Slave)
                    
                    // interfaccia MISO verso il produttore (Dato che riceve da Slave viene poi inviato a Produttore)
                    output reg       o_RX_DV,     // Se alto il byte ricevuto sulla linea MISO è stato re-impacchettato in forma di byte ed è valido 
                    output reg [DATA_SIZE-1:0] o_RX_Byte,   // Byte ricevuto sequenzialmente sulla linea MISO e re-impacchettato dall'interfaccia SPI
                    
                    /*interfaccia master-slave*/
                    
                    //clock di trasmissione generato internamente all'interfaccia SPI
                    output wire o_SPI_Clk, 
                    //linea MISO
                    input  wire i_SPI_MISO,
                    //linea MOSI
                    output reg o_SPI_MOSI,
                    output reg [2:0] ss
                    );
                    
  parameter BIT_DATA = $clog2(DATA_SIZE);
  
  //DECODER PER SLAVE SELECTOR
  
  always@(slave_selector)
  case(slave_selector)
  2'b00 : ss = 3'b110; //display
  2'b01 : ss = 3'b101; //manor
  2'b10 : ss = 3'b011; //cellar
  default : ss = 3'b110; //display
  endcase
  
      
  //segnali di sincronizzazione della trasmissione
  /*
  // CPHA=0 MOSI aggiornato sul fronte di discesa
  //        MISO aggiornato sul fronte di salita
  // CPHA=1 MOSI aggiornato sul fronte di salita
  //        MISO aggiornato sul fronte di discesa
  */
  wire w_CPOL;          // Clock polarity
  
  //memorizzazione interna del byte ricevuto dal produttore (disaccoppiamento produttore-interfaccia)
  wire [DATA_SIZE-1:0]  prod_data;      
  
  //contatore dati spediti
  wire [BIT_DATA-1:0] count_data_S; //l'interfaccia MOSI gestisce 1 byte alla volta quindi la dimensione di questo contatore è fissa    
  wire hit_d;              //hit_d=1 tutti i dati del byte sono stati spediti
  
  //contatore dati ricevuti
  wire [BIT_DATA-1:0] count_data_R; //l'interfaccia MISO gestisce 1 byte alla volta quindi la dimensione di questo contatore è fissa   
  wire hit_r;              //hit_r=1 tutti i dati del byte sono stati ricevuti 
  
  //segnali di controllo provenienti dalla FSM
  wire en_d;                //indica che la fase di trasmissione è in corso
  wire en_oclk;             //abilita la generazione del clock di trasmissione
  wire clear_d;            //trasmissione completata si possono ripristinare i valori iniziali
  
  /* last_LSB=1 indica l'ultimo colpo di clock della trasmissione 
  del LSB lungo la linea MOSI*/
  wire last_LSB; 
  
  /* last_edge=1 indica che l'ultimo edge (salita/discesa) è stato rilevato*/
  wire last_edge; 
  
  //Segnali di abilitazione ricezione/trasmissione
   wire enableRX, enableTX;

  
  /*
  //FUNZIONAMENTO GENERALE
  */
  // Definizione della Clock Polarity in funzione della modalità di funzionamento:
  assign w_CPOL = (SPI_MODE==2 || SPI_MODE==3) ? 1'b1 : 1'b0;
  
  /*Definizione del clock di trasmissione e degli enable di trasmissione/ricezione 
  in funzione della modalità di funzionamento*/ 
   top_clk_gen_mode #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER), .DATA_SIZE(DATA_SIZE)) TP_0 (.clk(clk), .rst(rst), .en_oclk(en_oclk),
  .clear_d(clear_d),.o_SPI_Clk(o_SPI_Clk),.enableRX(enableRX), .enableTX(enableTX), 
  .last_edge(last_edge), .idle_v(w_CPOL));
  
  //QUESTO DIPENDE DALLA MODALITà, IN 00 ad esempio
  //enableTX => abilitato in fronte salita (mando in salita)
  //enableRx => abilitato in fronte discesa (ricevo in discesa)
  /*
  //CANALE DI TRASMISSIONE
  */
  /*Registro di Input: campionamento e memorizzazione del dato in ingresso nell'interfaccia SPI 
  per far si che il produttore non debba tenere il byte stabile fino alla fine della trasmissione*/  
  register #(.SIZE(DATA_SIZE)) BYTE_IN_REG(.clk(clk), .rst(rst),.en(i_TX_DV),.data_in(i_TX_Byte),
  .data_out(prod_data));
   
  //macchina a stati che implementa il controllo della trasmissione
  fsm_SPI_master FSM_MASTER(.clk(clk), .rst(rst), .last_edge(last_edge),.tx(i_TX_DV),
  .en_d(en_d), .clear_d(clear_d),.en_oclk(en_oclk));
  
  /*La SPI è pronta per una nuova trasmissione: o_TX_Ready=1 (Il produttore può inviare nuovo dato a Master)
  1) Di default (rst==1) la SPI deve essere disponibile ad accettare nuove transazioni,
  2) una richiesta di trasmissione (i_TX_DV==1) rende indisponibile la SPI ad accettare nuove transazioni
  3) quando viene completato il ciclo di trasmissione del LSB verso lo slave la SPI deve tornare disponibile*/
  Ready_Gen #(.HALF_BIT_NUM(CLKS_PER_HALF_BIT)) 
            R_GEN(.clk(clk), .rst(rst),.req(i_TX_DV),.set(hit_d),.ready(o_TX_Ready),
            .stop(last_LSB));    
       
  /*Gestione dell'interfaccia MOSI verso lo slave*/
  always@(posedge clk, posedge rst)
  if (rst==1'b1) o_SPI_MOSI<=1'b0;
  else if (enableTX==1'b1)
       o_SPI_MOSI<=prod_data[count_data_S];     
  
  /*Contatore dati trasmessi lungo la linea MOSI (abilitato da enableTX): 
  da 7 a 0 visto che la trasmissione avviene da MSB a LSB
  hit_d=1 indica che sulla porta MOSI verso lo slave stiamo trasmettendo LSB
  */
  counter #(.MAX(DATA_SIZE),.N_BIT(BIT_DATA)) CNT_DATA_S(.clk(clk), .rst(rst),.en(enableTX), 
  .clear(clear_d), .count(count_data_S), .hit(hit_d));
  
  /*
  //CANALE DI RICEZIONE
  */
  /*Gestione dell'interfaccia MISO dallo slave*/ 
  always@(posedge clk, posedge rst)
  if (rst==1'b1) o_RX_Byte<={DATA_SIZE{1'b0}};
  else if (enableRX==1'b1) 
       o_RX_Byte<={o_RX_Byte[DATA_SIZE-2:0],i_SPI_MISO};
       
  /*Contatore dati ricevuti lungo la linea MISO (abilitato da enableRX): 
  da 7 a 0 per riutilizzare lo stesso contatore, 
  ma si noti che il primo bit ricevuto viene scritto nella posizione meno significativa*/
  counter #(.MAX(DATA_SIZE),.N_BIT(BIT_DATA)) CNT_DATA_R(.clk(clk), .rst(rst),.en(enableRX), 
  .clear(1'b0), .count(count_data_R), .hit(hit_r));
  
  /*Registro di Output: se alto segnala al produttore che il byte ricevuto sulla linea MISO è stato re-impacchettato ed 
  è valido*/
  always@(posedge clk, posedge rst)
  if (rst=='b1) o_RX_DV<=1'b0;
  else if  (enableRX==1'b1 && hit_r==1'b1 ) 
            o_RX_DV<=1'b1;
            else o_RX_DV<=1'b0;
endmodule
