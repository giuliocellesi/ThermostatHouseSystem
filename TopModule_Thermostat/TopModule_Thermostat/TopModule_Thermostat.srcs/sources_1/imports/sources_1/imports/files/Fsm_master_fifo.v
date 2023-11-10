`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mascia Lorenzo, Are Emanuele
// 
// Create Date: 20.05.2023 16:47:01
// Design Name: 
// Module Name: Fsm_master_fifo
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

//rd -> segnale proveniente dal timer globale che segnale lettura in burst mode da entrambe le fifo
//we -> segnale che viene posto ad 1 nel momento in cui è necessario scrivere nelle fifo (quando si ha cambiamento day/night, summer/winter , alarm ...)
//tx_ready -> segnale che indica l'avvenuta ricezione del dato da parte della spi master dalla linea MISO, siamo pronti a trasmettere un nuovo dato
//hitr1 -> hit proveniente dal datapath del master, che indica che il contatore del manor (fifo 1) relativo allo svuotamento della fifo è arrivato al valore del contatore di memorizzazione relativo. Ovvero la fifo è stata svuotata completamente
//hitr2 -> hit proveniente dal datapath del master, che indica che il contatore della cellar (fifo 2) relativo allo svuotamento della fifo è arrivato al valore del contatore di memorizzazione relativo. Ovvero la fifo è stata svuotata completamente
//ss_f -> segnale che verrà poi utilizzato per determinare quale slave selezionare (tra fifo 1, fifo 2 e display)
//en_cr1 -> abilita contatore lettura manor
//en_cr2 -> abilita contatore lettura cellar
//clear -> segnale di clear che va ai contatori di lettura delle due fifo (abilitato in idle)
//en_cw -> abilita contatore scrittura di manor o cellar, sulla base del segnale id presente nel datapath
//sel -> segnale a 2 bit che decide cosa scrivere nella spi master (se niente, se d_in, se segnale che indica alla fifo di leggere o scrivere)
//read_end -> segnale che indica che la lettura da manor e cellar è stata completata
module Fsm_master_fifo(
input wire clk, rst,
input wire rd, we, tx_ready, hitr1, hitr2,
output reg [1:0]ss_f, reg en_cr1, en_cr2, clear, en_cw, read_end,
output reg [1:0] sel
    );
    
    parameter IDLE = 3'b000, /*Stato in cui aspetto richiesta di lettura o scrittura sulle due FIFO*/
    READ_REQ_1 = 3'b001, /*Stato in cui mando comando LEG alla fifo 1, per far si che essa capisca se deve memorizzare o rimuovere in burst*/
    READ_1 = 3'b010, /*Leggo dalla fifo 1, passo a read_req_2 solo quando il contatore di lettura mi indica che ho finito (ovvero ho acquisito dalla spi master (linea MISO) un numero di bit pari a quelli memorizzati in precedenza)*/
    READ_REQ_2 = 3'b011, /*Stato in cui mando comando LEG alla fifo 2, per far si che essa capisca se deve memorizzare o rimuovere in burst*/
    READ_2 = 3'b100, /*Leggo dalla fifo 2*/
    WRITE_REQ = 3'b101, /*Stato in cui mando comando MEM ad una delle due fifo, sulla base del segnale id nel dp; per far si che essa capisca se deve memorizzare o rimuovere*/
    WRITE = 3'b110;/*Scrivo sulla fifo 1 o 2 in base ad id, e incremento il contatore andando in WRITE INC per poi tornare in idle quando la spi mi avvisa che ho finito di trasmettere*/
    reg [2:0] state, state_nxt;
    
    //logica stato successivo
    always@(state, rd, we, tx_ready, hitr1, hitr2)
    case(state)
        IDLE : begin
            if(rd && tx_ready) state_nxt = READ_REQ_1;
            else if(we && !rd && tx_ready) state_nxt = WRITE_REQ;
            else state_nxt = IDLE;
        end
        READ_REQ_1 : begin
            if(tx_ready) state_nxt = READ_1;
            else state_nxt = READ_REQ_1;
        end
        READ_1 : begin
            if(hitr1) state_nxt = READ_REQ_2;
            else state_nxt = READ_1;
        end
        READ_REQ_2 : begin
            if(tx_ready) state_nxt = READ_2;
            else state_nxt = READ_REQ_2;
        end
        READ_2 : begin
            if(hitr2) state_nxt = IDLE;
            else state_nxt = READ_2;
        end
        WRITE_REQ : begin
            if(tx_ready) state_nxt = WRITE;
            else state_nxt = WRITE_REQ;
        end
        WRITE : begin
            if(tx_ready) state_nxt = IDLE;
            else state_nxt = WRITE;
        end
        default : state_nxt = IDLE;
    endcase
    
    //registro memorizzazione dello stato
    always@(posedge clk, posedge rst)
    if(rst) state <= IDLE;
    else state <= state_nxt;

    //logica uscite di Moore
    always@(state)
    case(state)
        IDLE : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b0000101;
        READ_REQ_1 : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b0100010;
        READ_1 : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b0110010;
        READ_REQ_2 : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b1000010;
        READ_2 : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b1001010;
        WRITE_REQ : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b1100011;
        WRITE : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b1100001;
        default : {ss_f, en_cr1, en_cr2, clear, sel} = 7'b0000101;
    endcase
    
    //logica uscite di Mealy
    always@(state, tx_ready, hitr2)
    if(state == WRITE && tx_ready) {en_cw, read_end} = 2'b10;
    else if(state == READ_2 && hitr2) {en_cw, read_end} = 2'b01;
    else {en_cw, read_end} = 2'b00;
    
endmodule
