`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 21.03.2023 15:44:27
// Design Name: 
// Module Name: SUB_SUM_DRIVER
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


module SUB_SUM_DRIVER(
input wire clk, rst, RUN, INCR_DB, DECR_DB, wire [4:0] DTR,
output wire [4:0] DTF
    );
    
    wire [4:0] DTM;
    wire INCR_DB_R, DECR_DB_R;
    
    MUX_2 #(5) mdt (.A(DTR), .B(DTF), .OUT(DTM), .SEL(RUN));
    
    //Porte AND per tenere conto di INCR e DECR solo se è stato già premuto CONF
    and ai (INCR_DB_R, RUN, INCR_DB); 
    and ad (DECR_DB_R, RUN, DECR_DB);
    
    //modulo che effettivamnte realizza incremento e decremento
    COUNTER_SS counter (.clk(clk), .rst(rst), .INCR_DB_R(INCR_DB_R), .DECR_DB_R(DECR_DB_R), .DTM(DTM), .DTF(DTF) );
    
endmodule
