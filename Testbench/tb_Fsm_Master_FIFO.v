`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2023 17:46:54
// Design Name: 
// Module Name: tb_Fsm_Master_FIFO
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


module tb_Fsm_Master_FIFO;
reg clk, rst;
reg rd, we, tx_ready, hitr1, hitr2;
wire read_end;
wire [1:0] ss_f, sel;
wire en_cr1, en_cr2, clear, en_cw, read_end;

Fsm_master_fifo FSM(.clk(clk), .rst(rst), .rd(rd), .we(we), .tx_ready(tx_ready), .hitr1(hitr1), .hitr2(hitr2), .ss_f(ss_f), .en_cr1(en_cr1), .en_cr2(en_cr2), .en_cw(en_cw), .clear(clear), .sel(sel), .read_end(read_end));
always 
#5 clk = ~clk;

integer i;

initial
begin
clk = 1'b0; rst = 1'b1;
rd = 1'b0; we = 1'b0; tx_ready = 1'b0; hitr1 = 1'b0; hitr2 = 1'b0;

#20 rst = 1'b0;
//qui siamo in IDLE
#50 {tx_ready, hitr1, hitr2} = 3'b111;
//Questi segnali non permettono di muoversi da questo stato, ma bisogna aspettare rd o we in combinazione con tx_ready
#50 {tx_ready, hitr1, hitr2} = 3'b000;

//alzo we
#50 we = 1'b1;
//ma non basta devo aspettare l'arrivo di tx_ready
#100 @(posedge clk) tx_ready = 1'b1;
#10 @(posedge clk)tx_ready = 1'b0; we = 1'b0;//per simulare il comportamento reale, all'arrivo di tx_ready we e rd vengono posti a 0, in quanto alla FSM arrivano come input i segnali in uscita dal relè
//nel mentre simuliamo che è arrivata una lettura, che rimane alta
//#60 rd = 1'b1; //lo stesso vale per rd

//ORA SONO IN WRITE_REQUEST
//ora aspetto tx_ready
//le variazioni degli altri segnali non permettono il cambiamento di stato
for(i=0; i < 16; i=i+1)begin
    #10 {we, rd, hitr1, hitr2} = i;
end

#10 {we, rd, hitr1, hitr2} = 4'd0;

//nel momento in cui arriva tx_ready mi sposto in WRITE 
#50 @(posedge clk)tx_ready = 1'b1;
#10 @(posedge clk)tx_ready = 1'b0;
//qui in write si aspetta nuovamente tx_ready ad 1 per tornare in IDLE, e nel frattempo en_cw andrà ad 1
//le variazioni degli altri segnali non permettono il cambiamento di stato
for(i=0; i < 16; i=i+1)begin
    #10 {we, rd, hitr1, hitr2} = i;
end

#10 {we, rd, hitr1, hitr2} = 4'd0;

#50 @(posedge clk)tx_ready = 1'b1;
#10 @(posedge clk)tx_ready = 1'b0;

//ora se arrivano we e rd insieme, la priorità è nella lettura, quindi si andrà comunque in READ_REQUEST_1

#50 rd = 1'b1; we = 1'b1;
//qui bisogna aspettare la conferma che è stato inviato il leg, quindi si aspetta  tx_ready ad 1
#50 @(posedge clk)tx_ready = 1'b1;
#10 @(posedge clk)tx_ready = 1'b0; rd = 1'b0; we = 1'b0;

//le variazioni degli altri segnali non permettono il cambiamento di stato
for(i=0; i < 16; i=i+1)begin
    #10 {we, rd, hitr1, hitr2} = i;
end

#10 {we, rd, hitr1, hitr2} = 4'd0;

#50 @(posedge clk)tx_ready = 1'b1;
#10 @(posedge clk)tx_ready = 1'b0;

//le variazioni degli altri segnali non permettono il cambiamento di stato
for(i=0; i < 16; i=i+1)begin
    #10 {we, rd, tx_ready, hitr2} = i;
end

#10 {we, rd, tx_ready, hitr2} = 4'd0;

//ora per passare allo stato di READ_REQUEST_2 si aspetta che il contatore di lettura del Manor raggiunga il valore del contatore di scrittura rispettivo
#50 hitr1 = 1'b1;
#10 hitr1 = 1'b0;

//le variazioni degli altri segnali non permettono il cambiamento di stato
for(i=0; i < 16; i=i+1)begin
    #10 {we, rd, hitr1, hitr2} = i;
end

#10 {we, rd, hitr1, hitr2} = 4'd0;
#50 @(posedge clk)tx_ready = 1'b1;
#10 @(posedge clk)tx_ready = 1'b0;

//le variazioni degli altri segnali non permettono il cambiamento di stato

//qui bisogna aspettare la conferma che è stato inviato il leg, quindi si aspetta  tx_ready ad 1
for(i=0; i < 16; i=i+1)begin
    #10 {we, rd, tx_ready, hitr1} = i;
end

#10 {we, rd, tx_ready, hitr1} = 4'd0;

//ora per passare allo stato di READ_REQUEST_2 si aspetta che il contatore di lettura della Cellar raggiunga il valore del contatore di scrittura rispettivo
#65 hitr2 = 1'b1;
#10 hitr2 = 1'b0;

//In questo momento si passa dallo stato READ allo stato di IDLE e si alza il segnale read_end

#200 $stop;
end

endmodule
