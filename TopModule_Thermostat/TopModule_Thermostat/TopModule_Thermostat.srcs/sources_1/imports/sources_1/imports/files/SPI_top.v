`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2021 10:15:44
// Design Name: 
// Module Name: SPI_top
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


module SPI_top     #(parameter SPI_MODE = 2,                      //modalità di trasmissione
                    parameter SPI_CLK_DIVIDER = 8,                //se vogliamo che la SPI lavori a 25 MHz e la scheda lavora a 100 MHz
                    parameter CLKS_PER_HALF_BIT = SPI_CLK_DIVIDER/2,               //SPI_CLK_DIVIDER/2
                    parameter MAX_EDGE_GEN = SPI_CLK_DIVIDER*2,
                    parameter DATA_SIZE = 8,
                    parameter DATA_SIZE_B = 4
                    )(
                    input wire clk, rst, //segnali globali di controllo
                    
                    //INPUT MASTER-SLAVE FIFO
                    
                    //slave selector
                    input wire[1:0] slave_selector,
                    
                    /*interfaccia MOSI verso il produttore*/
                    // i_TX_Byte_M --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [DATA_SIZE-1:0]  i_TX_Byte_M,       
                    //
                     // i_TX_Byte_S --> Byte da trasmettere indietro al produttore sulla linea MISO
                    input wire [DATA_SIZE-1:0]  i_TX_Byte_DISPLAY,      
                    input wire [DATA_SIZE-1:0]  i_TX_Byte_MANOR,     
                    input wire [DATA_SIZE-1:0]  i_TX_Byte_CELLAR,     
                      
                    // i_TX_DV_M --> Se alto il byte ricevuto dal produttore è valido
                    input wire        i_TX_DV_M,
                    
                    
                    // i_TX_DV_S --> Se alto il byte ricevuto dal consumatore è valido
                    input wire        i_TX_DV_DISPLAY,
                    input wire        i_TX_DV_MANOR,
                    input wire        i_TX_DV_CELLAR,
                    
                    //INPUT PER MASTER-SLAVE BOTTONI
                                        /*interfaccia MOSI verso il produttore*/
                    // i_TX_Byte_M --> Byte da trasmettere al consumatore sulla linea MOSI
                    input wire [DATA_SIZE_B-1:0]  i_TX_Byte_M_btns,       
                     // i_TX_Byte_S --> Byte da trasmettere indietro al produttore sulla linea MISO
                    input wire [DATA_SIZE_B-1:0]  i_TX_Byte_S_btns,        
                    // i_TX_DV_M --> Se alto il byte ricevuto dal produttore è valido
                    input wire        i_TX_DV_M_btns,
                    // i_TX_DV_S --> Se alto il byte ricevuto dal consumatore è valido
                    input wire        i_TX_DV_S_btns,
                    
                    //OUTPUT PER MASTER-SLAVE BOTTONI
                    output wire       o_TX_Ready_M_btns,  
                    //  o_TX_Ready_S --> l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere indietro al produttore          
                    //output wire       o_TX_Ready_S,        
                    // interfaccia MISO verso il produttore
                    output wire       o_RX_DV_M_btns,     // Se alto il byte ricevuto sulla linea MISO è completo ed è valido 
                    output wire [DATA_SIZE_B-1:0] o_RX_Byte_M_btns,   // Byte ricevuto sequenzialmente sulla linea MISO 
                    // interfaccia MOSI verso il consumatore
                    output wire       o_RX_DV_S_btns,     // Se alto il byte ricevuto sulla linea MOSI è completo ed è valido 
                    output wire [DATA_SIZE_B-1:0] o_RX_Byte_S_btns,  // Byte ricevuto sequenzialmente sulla linea MOSI 
                    
                    //  o_TX_Ready_M --> l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere al consumatore          
                    output wire       o_TX_Ready_M,  
                    //  o_TX_Ready_S --> l'interfaccia SPI è disponibile a ricevere un nuovo byte da trasmettere indietro al produttore          
                    //output wire       o_TX_Ready_S,        
                    // interfaccia MISO verso il produttore
                    output wire       o_RX_DV_M,     // Se alto il byte ricevuto sulla linea MISO è completo ed è valido 
                    output wire [DATA_SIZE-1:0] o_RX_Byte_M,   // Byte ricevuto sequenzialmente sulla linea MISO 
                    
                    
                    // interfaccia MOSI verso il consumatore
                    output wire o_RX_DV_DISPLAY,
                    output wire o_RX_DV_MANOR,     // Se alto il byte ricevuto sulla linea MOSI è completo ed è valido 
                    output wire o_RX_DV_CELLAR,
                    output wire [DATA_SIZE-1:0] o_RX_Byte_DISPLAY,    // Byte ricevuto sequenzialmente sulla linea MOSI 
                    output wire [DATA_SIZE-1:0] o_RX_Byte_MANOR,
                    output wire [DATA_SIZE-1:0] o_RX_Byte_CELLAR
                    );
                    
/*interfaccia master-slave*/
//clock di trasmissione generato internamente all'interfaccia SPI
wire SPI_Clk; 
//linea MISO
wire w_SPI_MISO;
//linea MOSI
wire w_SPI_MOSI; 

//Slave selector
wire [2:0] ss;
    
// Istanziazione SPI master
  SPI_master #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT), .DATA_SIZE(DATA_SIZE))
      DUT_M(.slave_selector(slave_selector), .rst(rst),.clk(clk),
          .i_TX_Byte(i_TX_Byte_M),.i_TX_DV(i_TX_DV_M), .o_TX_Ready(o_TX_Ready_M), 
          .o_RX_DV(o_RX_DV_M),.o_RX_Byte(o_RX_Byte_M),
          .o_SPI_Clk(SPI_Clk),.i_SPI_MISO(w_SPI_MISO),.o_SPI_MOSI(w_SPI_MOSI), .ss(ss)); //MISO E MOSI still connected to each other

/* In generale in una comunicazione SPI ci sono 3 frequenze di funzionamento: quella del master, quella dello slave e quella della comunicazione master-slave. 
La terza (w_SPI_Clk) può essere qualsiasi frequenza a patto che 
a) il master possa generarla e usarla (proporzionalità rispetto a un fattore di scaling) 
b) lo slave possa accettarla (proporzionalità rispetto a un fattore di scaling)
In questa implementazione master e slave operano alla stessa velocità di riferimento, ma non sempre DEVE essere così.
*/

// Istanziazione SPI slave
//DISPLAY --> 001
SPI_slave #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT), .DATA_SIZE(DATA_SIZE))
      DISPLAY(.SS(ss[0]), .rst(rst),.clk(clk), .i_SPI_Clk(SPI_Clk), .o_SPI_MISO(w_SPI_MISO), .i_SPI_MOSI(w_SPI_MOSI),
      .o_RX_DV(o_RX_DV_DISPLAY),.o_RX_Byte(o_RX_Byte_DISPLAY), .i_TX_Byte(i_TX_Byte_DISPLAY),.i_TX_DV(i_TX_DV_DISPLAY));

//MANOR  --> 010
SPI_slave #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT), .DATA_SIZE(DATA_SIZE))
      MANOR(.SS(ss[1]), .rst(rst),.clk(clk), .i_SPI_Clk(SPI_Clk), .o_SPI_MISO(w_SPI_MISO), .i_SPI_MOSI(w_SPI_MOSI),
      .o_RX_DV(o_RX_DV_MANOR),.o_RX_Byte(o_RX_Byte_MANOR), .i_TX_Byte(i_TX_Byte_MANOR),.i_TX_DV(i_TX_DV_MANOR));
      
//CELLAR  --> 100   
SPI_slave #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT), .DATA_SIZE(DATA_SIZE))
      CELLAR(.SS(ss[2]), .rst(rst),.clk(clk), .i_SPI_Clk(SPI_Clk), .o_SPI_MISO(w_SPI_MISO), .i_SPI_MOSI(w_SPI_MOSI),
      .o_RX_DV(o_RX_DV_CELLAR),.o_RX_Byte(o_RX_Byte_CELLAR), .i_TX_Byte(i_TX_Byte_CELLAR),.i_TX_DV(i_TX_DV_CELLAR));
      

//MASTER-SLAVE BOTTONI

wire SPI_Clk_B; 
//linea MISO
wire w_SPI_MISO_B;
//linea MOSI
wire w_SPI_MOSI_B; 

// Istanziazione SPI master
  SPI_master #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT), .DATA_SIZE(DATA_SIZE_B))
      MASTER_BUTTONS (.slave_selector(2'b00), .rst(rst),.clk(clk),
          .i_TX_Byte(i_TX_Byte_M_btns),.i_TX_DV(i_TX_DV_M_btns), .o_TX_Ready(o_TX_Ready_M_btns), 
          .o_RX_DV(o_RX_DV_M_btns),.o_RX_Byte(o_RX_Byte_M_btns),
          .o_SPI_Clk(SPI_Clk_B),.i_SPI_MISO(w_SPI_MISO_B),.o_SPI_MOSI(w_SPI_MOSI_B), .ss()); //Questa spi ha un solo slave, si seleziona continuamente
          
// Istanziazione SPI slave
SPI_slave #(.SPI_MODE(SPI_MODE),.SPI_CLK_DIVIDER(SPI_CLK_DIVIDER),.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT), .DATA_SIZE(DATA_SIZE_B))
      SLAVE_BUTTONS(.SS(1'b0), .rst(rst),.clk(clk), .i_SPI_Clk(SPI_Clk_B), .o_SPI_MISO(w_SPI_MISO_B), .i_SPI_MOSI(w_SPI_MOSI_B),
      .o_RX_DV(o_RX_DV_S_btns),.o_RX_Byte(o_RX_Byte_S_btns), .i_TX_Byte(i_TX_Byte_S_btns),.i_TX_DV(i_TX_DV_S_btns));

endmodule
