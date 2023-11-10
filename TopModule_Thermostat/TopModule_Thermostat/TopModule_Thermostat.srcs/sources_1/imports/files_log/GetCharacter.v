`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Cellesi Giulio
// 
// Create Date: 16.05.2023 15:22:55
// Design Name: 
// Module Name: GetCharacter
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


module GetCharacter #(parameter ADDR_WIDTH=4,
                 parameter DATA_WIDTH=248,
                 parameter CH_WIDTH=8 //character width
)(
input wire clk, rst, inc, update,
input wire [19:0] data_in,
output reg done, //high when all the messages has been iterated
output reg [CH_WIDTH-1:0] character //character width
);  

parameter DEPTH=(2**ADDR_WIDTH);
    
reg [407:0] data_out;
reg signed[8:0] index;
reg signed[8:0] index_nxt;
wire [87:0] where;
wire [CH_WIDTH-1:0] hour;
wire [CH_WIDTH*2-1:0] minutes;
wire [CH_WIDTH*2-1:0] temperature;
wire [ADDR_WIDTH-1:0] address; //memory address
wire [DATA_WIDTH-1:0] data_tmp;

// The ROM in which the messages to be printed in the log screen are saved: we have 10 different messages
RomParam #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) ROM(address, data_tmp);

// The module that decode the 20 bits signal recived from the auxiliar FIFO 
decodeMessage DECODE(.clk(clk), .rst(rst), .data_in(data_in), .update(update), .address(address), .where(where), .hour(hour), 
    .minutes(minutes), .temperature(temperature));

/*
Composition of the word that will be passed, character by character, to the UART.

-signal where: the first bits are used to indentify the place: "Manor" or "Wine Cellar"
-then there are 16 bits that rapresent the two character ": " (colon and space)
-signal hour: the character that rapresent the hour (a value between 0 and 5)
-then there are 8 bits that rapresent the space
-signal minutes: the two characters that rapresent the minutes (a value between 0 and 59)
-signal data_tmp: it contains the value that has been reed from the ROM (there are 10 different messages saved)
-signal temperature: the two characters that rapresent the temperature
-at the end we have the bits for the new line
*/
always @(where, hour, minutes, data_tmp, temperature)
begin
    data_out = {where, 16'b0011101000100000, hour, 8'b00111010, minutes, data_tmp, temperature, 8'd12};
end 
 
always @(posedge clk, posedge rst)
begin
    if(rst) index <= 9'b111111111;
    else index <= index_nxt;
end

/*
When the signal inc that comes from the FSM is high the singal index is incremented.
If the charcter indexed by the index is equal to decimal 12 it means that the trasmission of the message is ended so
we reset the index singal and we rise the done signal that will be an input of the FSM
*/
//always @(inc, index, character)
//begin
//    if(inc)
//        begin
//            if(character == 8'd12) begin index_nxt = 9'd0; done = 1'd1; end
//            else begin index_nxt = index+9'd1; done = 1'd0; end
//        end
//    else
//    begin 
//        index_nxt = index; 
//        done = 1'd0;
//    end
//end

always @(inc, index, character)
begin
    if(inc)
        begin
            if(character == 8'd12)  index_nxt = 9'b111111111; 
            else  index_nxt = index+9'd1;  
        end
    else  index_nxt = index; 
end

//always @(inc, index, character)
//begin
//    if(character == 8'd12)  index_nxt = 9'd0;
//    else if(inc)  index_nxt = index+9'd1;  
        
//    else  index_nxt = index; 
//end

always @(character)
begin
    if(character == 8'd12) done=1'b1;
    else done=1'b0;
end


/*
We extract the character from data_out thanks to the signal index
*/
always @(data_out, index) 
begin
    character = data_out[407-8*index -: 8]; 
end

endmodule
