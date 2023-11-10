`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Giulio Cellesi
//////////////////////////////////////////////////////////////////////////////////


module RomParam#(parameter ADDR_WIDTH=4,
                 parameter DATA_WIDTH=248
)(
input wire [ADDR_WIDTH-1:0] address, //memory address
output wire [DATA_WIDTH-1:0] data_out //data read from memory
);  

parameter DEPTH=(2**ADDR_WIDTH);

reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

initial
begin
$readmemb("C:/Universit/SEA_2/messagesRam.mem",memory);
end

//Memory Read
assign data_out = memory[address];
   
endmodule