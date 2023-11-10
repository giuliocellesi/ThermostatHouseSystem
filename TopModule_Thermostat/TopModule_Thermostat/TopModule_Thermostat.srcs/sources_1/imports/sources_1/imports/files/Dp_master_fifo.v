`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 20.05.2023 17:29:41
// Design Name: 
// Module Name: Dp_master_fifo
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

//INPUT DA FSM_MASTER FIFO
//ss_f -> segnale che verrà poi utilizzato per determinare quale slave selezionare (tra fifo 1, fifo 2 e display)
//en_cr1 -> segnale che abilita contatore lettura manor
//en_cr2 -> segnale che abilita contatore lettura cellar
//clear -> segnale che va ai contatori di lettura delle due fifo (abilitato in idle)
//en_cw -> abilita contatore scrittura di manor o cellar, sulla base del segnale id qui definito
//sel -> segnale che decide cosa scrivere nella spi master (se niente, se d_in, se segnale che indica alla fifo di leggere o scrivere)
//read_end -> indica che è stata effettuata la lettura anche dell'ultima fifo

//INPUT DA SISTEMA TERMOSTATO
//data_in -> "pacchetto" a 22 bit da trasmettere contenente 4 + 1 + 3 + 8 + 6  bit ovvero : (OpCode +Dove + ora + minuti + temperatura corrente)
//we -> segnale che viene posto ad 1 nel momento in cui è necessario scrivere nelle fifo (quando si ha cambiamento day/night, summer/winter , alarm ...)
//DTF, RTR, WS -> Segnali per il display

//INPUT DA SPI MASTER
//o_RX_DV -> segnale che indica la ricezione della parola dalla linea MISO della spi master

//OUTPUT VERSO SPI MASTER
//data_to_send -> parola da inviare sulla linea MOSI
//ss -> slave selector

//OUTPUT VERSO FIFO DI APPOGGIO PER UART
//insert -> indica quando effettuare inserimento nella fifo ausiliaria


//OUTPUT VERSO FSM_MASTER_FIFO
//hitr1 -> hit che indica che il contatore del manor (fifo 1) relativo allo svuotamento della fifo è arrivato al valore del contatore di memorizzazione relativo. Ovvero la fifo è stata svuotata completamente
//hitr2 -> hit che indica che il contatore della cellar (fifo 2) relativo allo svuotamento della fifo è arrivato al valore del contatore di memorizzazione relativo. Ovvero la fifo è stata svuotata completamente

module Dp_master_fifo #(parameter SIZE_FIFO = 5)(
input wire clk, rst,
input wire [1:0]ss_f, wire en_cr1, en_cr2, read_end, en_cw, clear, wire [1:0] sel, /*segnali proveniente dalla Fsm_master_fifo*/
input wire [19:0] data_in, wire we, wire [4:0] DTF, wire [5:0] RTR, wire WS,/*segnali provenienti dal resto del sistema termostato*/
input wire o_RX_DV,/*segnali provenienti dalla spi master*/
output reg [1:0] ss, wire [19:0] data_to_send,
output wire hitr1, hitr2, /*Segnali che andranno alla Fsm_master_fifo*/
output wire insert
    );
    
    reg [19:0] data_in_r;
    reg [19:0] segi;
    
    //REGISTRO DATA_IN
    always@(posedge clk, posedge rst)
    if(rst) data_in_r <= 20'd0;
    else if(we && ss_f == 2'd0) data_in_r <= data_in;    //we in ingresso a al dp, va in and con ss_f a 00, per far si che il registro data_in non venga aggiornato mentra si sta facendo scrittura
    
    //REGISTRO SEGi
    always@(posedge clk, posedge rst)
    if(rst) segi <= 20'd0;
    else segi <= {DTF, RTR, WS, 8'd0}; //deve essere adattato a 20 bit
    
    wire id;
    assign id = data_in_r[15]; //id corrisponde al quinto bit 
    
    //SELETTORE PER SELEZIONARE QUALE DATO INVIARE
    Selector_master_fifo SELECTOR(.data_in(data_in_r), .segi(segi), .mem(20'b11111111110000000000), .leg(20'b00000000001111111111), .sel(sel), .ss_f(ss_f != 2'd0), .d_out(data_to_send));

    //DECODER PER DECIDERE QUALE CONTATORE DI SCRITTURA ATTIVARE
    reg en_write_manor, en_write_cellar;
    //SUPPONENDO CHE ID = 0 SI INDICA MANOR E ID = 1 SI INDICA CELLAR
    always@(id, en_cw)
    casex({en_cw, id})
    2'b0x : {en_write_manor, en_write_cellar} = 2'b00;
    2'b10 : {en_write_manor, en_write_cellar} = 2'b10;
    2'b11 : {en_write_manor, en_write_cellar} = 2'b01;
    default : {en_write_manor, en_write_cellar} = 2'b00;
    endcase
    
    //CONTATORI SCRITTURA FIFO
    
    //Supponendo di avere 32 parole (quindi 5 bit)
    wire [SIZE_FIFO-1:0] cnt_write_manor, cnt_write_cellar;
    wire max_write_manor, max_write_cellar; //segnali per fermare i contatori quando hanno raggiunto il massimo e per controllare se i contatori di scrittura sono arrivati a leggere tutte le parole scritte nelle fifo
    counter_std#(SIZE_FIFO, {{SIZE_FIFO-1{1'b0}}, 1'b1}) COUNTER_WRITE_MANOR(.clk(clk), .rst(rst), .clear(read_end), .enable(en_write_manor && !max_write_manor), .cnt(cnt_write_manor));
    counter_std#(SIZE_FIFO, {{SIZE_FIFO-1{1'b0}}, 1'b1}) COUNTER_WRITE_CELLAR(.clk(clk), .rst(rst), .clear(read_end), .enable(en_write_cellar && !max_write_cellar), .cnt(cnt_write_cellar));
    
    assign max_write_manor = (cnt_write_manor == {SIZE_FIFO{1'b1}}) ? 1'b1 : 1'b0;
    assign max_write_cellar = (cnt_write_cellar == {SIZE_FIFO{1'b1}}) ? 1'b1 : 1'b0;
    
    //CONTATORI LETTURA FIFO
    
    wire [SIZE_FIFO-1:0] cnt_read_manor, cnt_read_cellar;
    counter_std#(SIZE_FIFO, {{SIZE_FIFO-1{1'b0}}, 1'b1}) COUNTER_READ_MANOR(.clk(clk), .rst(rst), .clear(clear), .enable(en_cr1 && o_RX_DV), .cnt(cnt_read_manor));
    counter_std#(SIZE_FIFO, {{SIZE_FIFO-1{1'b0}}, 1'b1}) COUNTER_READ_CELLAR(.clk(clk), .rst(rst), .clear(clear), .enable(en_cr2 && o_RX_DV), .cnt(cnt_read_cellar));
    
    assign hitr1 = (cnt_read_manor == cnt_write_manor) ? 1'b1 : 1'b0;
    assign hitr2 = (cnt_read_cellar == cnt_write_cellar) ? 1'b1 : 1'b0;
    
    //SLAVE SELECTOR
    //gestione invio slave selector a spi master
    always@(ss_f, id)
    casex({ss_f, id})
    4'b00x : ss = 2'b00; //seleziono display
    4'b01x : ss = 2'b01;
    4'b10x : ss = 2'b10;
    4'b110 : ss = 2'b01;
    4'b111 : ss = 2'b10;
    default : ss = 2'b00;
    endcase
    
    //GESTIONE OUTPUT PER FIFO DI APPOGGIO A UART
    assign insert = (en_cr1 || en_cr2) && o_RX_DV;
endmodule
