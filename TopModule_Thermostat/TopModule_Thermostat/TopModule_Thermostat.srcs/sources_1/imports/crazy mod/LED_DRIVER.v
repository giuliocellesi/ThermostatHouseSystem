`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Miccio Carlo, Paolo Galiano Bove
// 
// Create Date: 21.03.2023 15:54:22
// Design Name: 
// Module Name: LED_DRIVER
// Project Name: Thermostat Control System
// Target Devices: Basys 3
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


module LED_DRIVER(
        input wire clk, rst,
        input wire[1:0] LED,
        output reg[15:0] LED_OUT
    );
    parameter off=2'b00, all=2'b01, evenodd=2'b10,on=2'b11;
    /*
        Si è preferito usare nomi intuitivi che evocassero, a ogni combinazione
        dei segnali in ingresso, il relativo comportamento dei led
    */
    reg[15:0] led_out_nxt;
    wire ena;
    
    always@(posedge clk, posedge rst)
    if(rst==1'b1) LED_OUT={16{1'b0}};
    else if(ena==1'b1)LED_OUT=led_out_nxt;
    
    always@(LED,LED_OUT)
    begin
        case(LED)
            off: led_out_nxt={16{1'b0}}; //Se arriva 
            all: if(LED_OUT == {16{1'b0}}) led_out_nxt= {16{1'b1}};
                 else led_out_nxt= {16{1'b0}};    
            evenodd: if(LED_OUT==16'b0101010101010101) led_out_nxt=16'b1010101010101010;  
                     else led_out_nxt=16'b0101010101010101;
            on: led_out_nxt={16{1'b1}};
        default: led_out_nxt={16{1'b0}};
        endcase      
    end
    
    /*
      Il contatore di clock istanziato per fare in modo che possa contare fino a
      mezzo secondo.
    */
    /*PER SCHEDA: .QTY(5),.TU(10000000), PER TB: .QTY(5),.TU(10)*/
    CLOCK_COUNTER #(.QTY(5),.TU(10000000))cc(.clk(clk),.rst(rst),.HIT(ena));
endmodule
