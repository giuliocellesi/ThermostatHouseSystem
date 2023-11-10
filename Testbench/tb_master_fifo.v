`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2023 18:07:12
// Design Name: 
// Module Name: tb_master_fifo
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


module tb_master_fifo;
reg clk, rst;
reg tx_ready, rd;
reg [19:0] data_in; 
reg we, WS, o_RX_DV;
reg [4:0] DTF;
reg [5:0] RTR;
wire [1:0] ss;
wire [19:0] data_to_send;
wire insert, read_end;

parameter SIZE_FIFO = 2;

Master_fifo_display#(.SIZE_FIFO(SIZE_FIFO)) mod(.clk(clk), .rst(rst), .tx_ready(tx_ready), .rd(rd), .we(we), .data_in(data_in), .DTF(DTF), 
.RTR(RTR), .WS(WS), .read_end(read_end), .insert(insert), .data_to_send(data_to_send), .ss(ss));

always 
#5 clk = ~clk;

integer i;

//Funzione per effettuare scrittura
task Write;
    input wire [19:0] data;
    
    begin
        #5@(negedge clk) data_in = data; //cambio valore di data_in per scrivere in manor o in cellar
        #10@(negedge clk) we = 1'b1;
        #50@(posedge clk) tx_ready = 1'b1;//simulo display che termina la trasmissione dopo 50 unità di tempo
        #10@(posedge clk) tx_ready = 1'b0; we = 1'b0;//il segnale tx_ready corrisponde a o_RX_DV e rimane alto per 1 colpo di clock
        //invio di MEM
        #50@(posedge clk) tx_ready = 1'b1;
        #10@(posedge clk) tx_ready = 1'b0;
        //WAIT
        //Aspetto avvenuta scrittura
        #50@(posedge clk) tx_ready = 1'b1;
        #10@(posedge clk) tx_ready = 1'b0;
        //ritorno in IDLE e en_cw va ad 1
    end
endtask

//Funzione per effettuare lettura
task Read;
    input wire [4:0] num_writing_in_manor;
    input wire [4:0] num_writing_in_cellar;
    begin
        #50@(negedge  clk) rd = 1'b1;
        #50@(posedge clk) tx_ready = 1'b1;
        #10@(posedge clk) tx_ready = 1'b0; rd = 1'b0;
        
        #50@(posedge clk) tx_ready = 1'b1;
        #10@(posedge clk) tx_ready = 1'b0;
        
        for(i = 0; i< num_writing_in_manor; i = i + 1)begin
            #50@(posedge clk) tx_ready = 1'b1;
            #10@(posedge clk) tx_ready = 1'b0;
        end
        
        #50@(posedge clk) tx_ready = 1'b1;
        #10@(posedge clk) tx_ready = 1'b0;
        
        for(i = 0; i< num_writing_in_cellar; i = i + 1)begin
            #50@(posedge clk) tx_ready = 1'b1;
            #10@(posedge clk) tx_ready = 1'b0;
        end
    end
endtask

initial
begin
clk = 1'b0; rst = 1'b1;
tx_ready = 1'b0; rd = 1'b0; we = 1'b0; data_in = 20'd5;
DTF = 5'd5; RTR = 6'd5; WS = 1'b0;
o_RX_DV = 1'b0;
#10 rst = 1'b0;

//provo scrittura in manor

Write(20'b11010101101011000010);

//provo scrittura in cellar

Write(20'b11010101101011010010);

//provo lettura

Read(5'd1, 5'd1);

//provo a scrivere completamente in manor

for(i=0; i < 2**SIZE_FIFO - 1; i = i+1)begin
Write(20'b11010101101011000010);
end

//provo a scrivere completamente in cellar

for(i=0; i < 2**SIZE_FIFO - 1; i = i+1)begin
Write(20'b11010101101011010010);
end

//scrittura ulteriore in manor
Write(20'b11010101101011000010);

//scrittura ulteriore in cellar
Write(20'b11010101101011010010);

//lettura 
Read(2**SIZE_FIFO - 1, 2**SIZE_FIFO - 1); 

#200 $stop;
end

endmodule
