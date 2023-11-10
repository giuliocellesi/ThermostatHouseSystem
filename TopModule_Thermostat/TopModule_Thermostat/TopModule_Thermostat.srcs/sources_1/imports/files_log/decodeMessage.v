`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Cellesi Giulio
// 
// Create Date: 22.05.2023 12:13:44
// Design Name: 
// Module Name: decodeMessage
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


module decodeMessage(input wire clk, rst,
input wire [19:0] data_in, //the data come from the FIFO
input wire update, //update equal to one means that we have to read a message from the FIFO, so a new data_in has been read.
output wire [3:0] address, //the address from which to read from memory
output reg [87:0] where, //the ASCII code of the place: can be "Manor" or "Wine Cellar"
output reg [7:0] hour, //the ASCII code of the hour (from 0 to 5)
output reg [15:0] minutes, //the ASCII code of the minutes (from 0 to 59)
output reg [15:0] temperature //the ASCII code from the current temperature 
    );

/*
Auxiliary signals to calculate the values of the output signals
*/
wire where_tmp;
wire [2:0] hour_tmp;
wire [5:0] minutes_tmp;
wire [5:0] temperature_tmp;
reg [7:0] aux_min0, aux_temp0, aux_min1, aux_temp1;

/*
The data_in message is composed as following:
 - The first 4 bits for the address
 - 1 bit for the place
 - 3 bits for the hour
 - 6 bits for the minutes
 - 6 bits for the temperature
 
In the following registers the previous values are saved 
*/

register #(4) R11(.data_in(data_in[19:16]), .en(update), .clk(clk), .rst(rst), .data_out(address));
register #(1) R12(.data_in(data_in[15:15]), .en(update), .clk(clk), .rst(rst), .data_out(where_tmp));
register #(3) R13(.data_in(data_in[14:12]), .en(update), .clk(clk), .rst(rst), .data_out(hour_tmp));
register #(6) R14(.data_in(data_in[11:6]), .en(update), .clk(clk), .rst(rst), .data_out(minutes_tmp));
register #(6) R15(.data_in(data_in[5:0]), .en(update), .clk(clk), .rst(rst), .data_out(temperature_tmp));

/*
If where_tmp is one the place is "Wine Cellar" if is zero is "Manor"
We saved the ASCII code in the output signal: where
*/
always @(where_tmp)
begin
    if(where_tmp) where = 88'b0101011101101001011011100110010100100000010000110110010101101100011011000110000101110010;
    else where = 40'b0100110101100001011011100110111101110010;
end

/*
We convert from the binary value to the ASCII code 
This works because the number 0 in the ASCII code is 48.
*/
always @(hour_tmp)
    hour = hour_tmp + 8'd48;

/*
The last digit of the minuntes is saved in the aux_min0 signal calculating the carry-over after dividing by 10
Then we divide the minutes by 10 obtaining the first digit and we save it in the aux_min1 signal.

Example:

The decimal value of minutes_tmp signal is 12, 
 
 minutes_tmp%10 -> 12%10 = 2
 minutes_tmp/10 -> 12/10 = 1
 
*/
always @(minutes_tmp)
begin
    aux_min0 = minutes_tmp%10;
    aux_min1 = minutes_tmp/10;
end

/*
We composed the minutes ASCII code, the first 8 bits will be equal to the aux_min1 signal and the last 8
will be equal to the aux_min0 signal. 
In both cases we add to the decimal value 48 as before.
*/
always @(aux_min0, aux_min1)
begin
    minutes =  {aux_min1 + 8'd48, aux_min0 + 8'd48};

end

/*
The same algorithm as for the minutes.
We save the ASCII code of the temperature in the output signal: temperature
*/
always @(temperature_tmp)
begin
    aux_temp0 = temperature_tmp%10;
    aux_temp1 = temperature_tmp/10;
end

always @(aux_temp0, aux_temp1)
begin
    temperature =  {aux_temp1 + 8'd48, aux_temp0 + 8'd48};
end

endmodule
