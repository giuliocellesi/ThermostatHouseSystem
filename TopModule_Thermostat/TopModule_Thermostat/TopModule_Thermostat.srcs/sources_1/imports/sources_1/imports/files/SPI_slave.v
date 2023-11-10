`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2021 10:14:21
// Design Name: 
// Module Name: SPI_slave
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


module SPI_slave #( parameter SPI_MODE = 3,                         //modalità di trasmissione
                    parameter SPI_CLK_DIVIDER = 8,                  //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2, //SPI_CLK_DIVIDER/2
                    parameter DATA_SIZE = 8
                    )(
                    input wire clk, rst, //segnali globali di controllo
                    input wire SS,
                    /*interfaccia MISO dal consumatore*/
                    // i_TX_Byte --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [DATA_SIZE-1:0]  i_TX_Byte,        
                    // i_TX_DV --> Se alto il byte ricevuto è valido
                    input wire        i_TX_DV,
                    //  o_TX_Ready --> 1: l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere su MISO          
                    //output wire       o_TX_Ready,      
                    // interfaccia MOSI verso il consumatore
                    output wire       o_RX_DV,     // Se alto il byte ricevuto sulla linea MOSI è stato re-impacchettato in forma di byte ed è valido 
                    output wire [DATA_SIZE-1:0] o_RX_Byte,   // Byte ricevuto sequenzialmente sulla linea MOSI e re-impacchettato dall'interfaccia SPI
                    /*interfaccia master-slave*/
                    //clock di ricezione generato internamente all'interfaccia SPI
                    input wire i_SPI_Clk, 
                    //linea MISO connessa al master
                    output wire o_SPI_MISO,
                    //linea MOSI connessa al master
                    input wire i_SPI_MOSI  
                    );
                    
     parameter BIT_SIZE = $clog2(DATA_SIZE);
                    
     reg [DATA_SIZE-1:0] RX_Byte; //registro interno di disaccoppiamento ricezione-consumazione
     reg [BIT_SIZE-1:0] RX_cnt;  //contatore dati ricevuti
     wire hit_cnt;      //se alto indica che tutti i dati sono stati ricevuti
     reg RX_valid;      //validità del dato verso il consumatore
     
     wire [$clog2(SPI_CLK_DIVIDER)-1:0] CLK_cnt;//contatore cc di sistema per identificare la fine del LSB
     wire Last_LSB;     //ultimo colpo di clock di sistema del LSB
     
     reg [DATA_SIZE-1:0] TX_Byte; //registro interno di disaccoppiamento consumatore-trasmissione
     reg [BIT_SIZE-1:0] TX_cnt;  //contatore dati trasmessi
    
     wire w_CPOL;       // Clock polarity
     
     wire r_edge, f_edge;     //fronti di salita e discesa del SPI clock 
     wire enableRX, enableTX; //abilitazione di ricezione e trasmissione
     wire enable_CHRX;        //segnale di abilitazione canale di ricezione
     wire disable_CHTX;       //segnale di disabilitazione canale di trasmissione
     
     //segnali per slave selector
     //per la gestione dello slave selector scolleghiamo la linea MISO nel momento in cui SS != 0
     //E manteniamo il clock allo stato iniziale nel momento in cui SS != 0 (lo facciamo coincidere con W_CPOL) 
     //in modo tale che, non facendo avanzare il clock, il sistema rimanga "fermo".
     reg ss_o_SPI_MISO; 
     wire ss_i_SPI_Clk;
     
     // Definizione della Clock Polarity in funzione della modalità di funzionamento:
     assign w_CPOL = (SPI_MODE==2 || SPI_MODE==3) ? 1'b1 : 1'b0;
      
     /*
     FUNZIONAMENTO GENERALE
     */
     modeAdapterS #(.SPI_MODE(SPI_MODE),.DATA_SIZE(DATA_SIZE)) CLK_GEN_SL(.clk(clk),.rst(rst), 
                    .TX_cnt(TX_cnt), .RX_cnt(RX_cnt),
                    .SPI_clk_M(ss_i_SPI_Clk),.enable_CHRX(enable_CHRX), 
                    .disable_CHTX(disable_CHTX),
                    .r_edge(r_edge), .f_edge(f_edge), .idle_v(w_CPOL), .enableTX(enableTX));
                    
    //Generazione dei segnali di abilitazione di ricezione e trasmissione   
    assign enableRX = (((SPI_MODE == 0 || SPI_MODE == 3) && r_edge == 1) ||
                        ((SPI_MODE == 1 || SPI_MODE == 2) && f_edge == 1)) ? 1'b1:1'b0;
    assign enableTX = (((SPI_MODE == 0 || SPI_MODE == 3) && f_edge == 1) ||
                        ((SPI_MODE == 1 || SPI_MODE == 2) && r_edge == 1)) ? 1'b1:1'b0;
    
     /*
     CANALE DI RICEZIONE
     */
     //Ricezione del dato dall'interfaccia SPI, il dato ricevuto viene scritto 
     //nel LSB di RX_Byte che disaccoppia campionamento da spedizione a consumatore 
     always@(posedge clk, posedge rst)
     if (rst==1'b1) RX_Byte<={DATA_SIZE{1'b0}};
     else if(enableRX == 1'b1) RX_Byte<={RX_Byte[DATA_SIZE-2:0],i_SPI_MOSI};  
     
     //Contatore dei dati ricevuti
     always@(posedge clk, posedge rst)
     if (rst==1'b1) RX_cnt<=DATA_SIZE-1;
     else if(RX_cnt==0 && enableRX == 1'b1 && enable_CHRX == 1'b1) RX_cnt <= DATA_SIZE-1;
     else if (enableRX == 1'b1 && enable_CHRX == 1'b1) RX_cnt<=RX_cnt-1;
     //hit_cnt==1 --> tutto il pacchetto è stato ricevuto
     assign hit_cnt=(RX_cnt==0)?1'b1:1'b0;
  
     /*Contatore dei CLK cycle rispetto al clock principale 
     al fine di identificare il LAST_LSB*/
     counter_up #(.MAX(SPI_CLK_DIVIDER),.N_BIT($clog2(SPI_CLK_DIVIDER))) 
     CNT_DATA_R(.clk(clk), .rst(rst),.en(hit_cnt),.count(CLK_cnt));
     assign Last_LSB=(CLK_cnt==SPI_CLK_DIVIDER-1)? 1'b1:1'b0;
     
     //Il dato è ritenuto pronto per la spedizione verso lo slave al termine della ricezione del LSB 
     always@(posedge clk, posedge rst)
     if (rst==1'b1) RX_valid<=1'b0;
     else RX_valid<=Last_LSB;
     
     //Dato impacchettato e valido per il consumatore
     assign o_RX_Byte=RX_Byte;
     assign o_RX_DV=RX_valid;
        
     /*
     CANALE DI TRASMISSIONE
     */
     //Caricamento dell'informazione da trasmettere nel registro interno 
     /*
     Consumatore risponde al produttore (i_TX_DV==1) TX_Byte viene caricato dal consumatore 
     Consumatore NON risponde al produttore (i_TX_DV==0) TX_Byte viene caricato con l'info ricevuta da MOSI 
     */
     always@(posedge clk, posedge rst)
     if (rst==1'b1) TX_Byte<={DATA_SIZE{1'b0}};
     else if (i_TX_DV==1'b1) TX_Byte<=i_TX_Byte;
          else if(RX_valid==1'b1) TX_Byte<=RX_Byte;
      
     
     /*Gestione dell'interfaccia MISO verso il master*/
     always@(posedge clk, posedge rst)
     if (rst==1'b1) ss_o_SPI_MISO<=1'b0;
     else if (enableTX == 1'b1) ss_o_SPI_MISO<=TX_Byte[TX_cnt];
  
     /*Conteggio dei dati trasmessi*/    
     always@(posedge clk, posedge rst)
     if (rst==1'b1) TX_cnt<=(DATA_SIZE-1);
     else if (enableTX == 1'b1 && disable_CHTX == 1'b0 && TX_cnt > 0) TX_cnt<=TX_cnt-{{BIT_SIZE-1{1'b0}},1'b1};
     else if (enableTX == 1'b1 && disable_CHTX == 1'b0 && TX_cnt == 0) TX_cnt <= DATA_SIZE-1;
     
     assign o_SPI_MISO = (SS == 1'b0)? ss_o_SPI_MISO : 1'bz;
     assign ss_i_SPI_Clk = (SS == 1'b0)? i_SPI_Clk : w_CPOL; //quando non si seleziona, si mantiene allo stato iniziale che dipende dalla clock polarity
           
endmodule
