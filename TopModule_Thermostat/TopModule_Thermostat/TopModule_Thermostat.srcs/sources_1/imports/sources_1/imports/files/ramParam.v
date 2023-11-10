`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.05.2020 15:13:54
// Design Name: 
// Module Name: ramParam
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


module ramParam #(
parameter ADDR_WIDTH=8,
parameter DATA_WIDTH=2
)(
input wire clk, //system clock signal
input wire chipsel, //memory enable signal
input wire write_en, //write enable signal
input wire [ADDR_WIDTH-1:0] address, //memory cell address
input wire [DATA_WIDTH-1:0] data_in, //data to be written
output reg [DATA_WIDTH-1:0] data_out //data to be written
);  

//-------------- Local Parameters---------------- 
parameter DEPTH=(2**ADDR_WIDTH);

//--------------MEM ---------------- 
reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

/*
//--------------Init RAM---------------- 
initial
begin 
$display("Loading Mem");
$readmemh("rams_init_file.mem",mem); 
end 
*/
    
// Memory Write Block 
// Write Operation allowed if chipsel and write_en are both high
always @ (posedge clk)
   if (chipsel==1'b1 && write_en==1'b1) 
    mem[address] <= data_in;

// Memory Read Block
// Read Operation allowed if chipsel is high and write_en is low 
always @ (posedge clk) 
  if (chipsel==1'b1 && write_en==1'b0)
    data_out <= mem[address];
   
endmodule
