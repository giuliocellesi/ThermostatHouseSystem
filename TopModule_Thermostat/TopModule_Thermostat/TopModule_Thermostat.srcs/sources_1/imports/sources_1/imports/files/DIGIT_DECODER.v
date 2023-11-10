`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Paolo Galiano Bove, Alessandro Monni
// 
// Create Date: 23.03.2023 18:58:23
// Design Name: 
// Module Name: DIGIT_DECODER
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


module DIGIT_DECODER(
    input wire[5:0] TO_CONVERT,
    output reg[4:0] D,U
    );
    
    always@(TO_CONVERT)
    begin
        case(TO_CONVERT) //semplice decoder che preso un valore intero decimale a due cifre lo splitta in unità e decine
            6'd41: {D,U}={5'd4,5'd1};
            6'd40: {D,U}={5'd4,5'd0};
            6'd39: {D,U}={5'd3,5'd9};
            6'd38: {D,U}={5'd3,5'd8};
            6'd37: {D,U}={5'd3,5'd7};
            6'd36: {D,U}={5'd3,5'd6};
            6'd35: {D,U}={5'd3,5'd5};
            6'd34: {D,U}={5'd3,5'd4};
            6'd33: {D,U}={5'd3,5'd3};
            6'd32: {D,U}={5'd3,5'd2};
            6'd31: {D,U}={5'd3,5'd1};
            6'd30: {D,U}={5'd3,5'd0};
            6'd29: {D,U}={5'd2,5'd9};
            6'd28: {D,U}={5'd2,5'd8};
            6'd27: {D,U}={5'd2,5'd7};
            6'd26: {D,U}={5'd2,5'd6};
            6'd25: {D,U}={5'd2,5'd5};
            6'd24: {D,U}={5'd2,5'd4};
            6'd23: {D,U}={5'd2,5'd3};
            6'd22: {D,U}={5'd2,5'd2};
            6'd21: {D,U}={5'd2,5'd1};
            6'd20: {D,U}={5'd2,5'd0};
            6'd19: {D,U}={5'd1,5'd9};
            6'd18: {D,U}={5'd1,5'd8};
            6'd17: {D,U}={5'd1,5'd7};
            6'd16: {D,U}={5'd1,5'd6};
            6'd15: {D,U}={5'd1,5'd5};
            6'd14: {D,U}={5'd1,5'd4};
            6'd13: {D,U}={5'd1,5'd3};
            6'd12: {D,U}={5'd1,5'd2};
            6'd11: {D,U}={5'd1,5'd1};
            6'd10: {D,U}={5'd1,5'd0};
            6'd9:  {D,U}={5'd0,5'd9};
            6'd8:  {D,U}={5'd0,5'd8};
            6'd7:  {D,U}={5'd0,5'd7};
            6'd6:  {D,U}={5'd0,5'd6};
            6'd5:  {D,U}={5'd0,5'd5};
            6'd4:  {D,U}={5'd0,5'd4};
            6'd3:  {D,U}={5'd0,5'd3};
            6'd2:  {D,U}={5'd0,5'd2};
            6'd1:  {D,U}={5'd0,5'd1};
            6'd0:  {D,U}={5'd0,5'd0};
            default:   {D,U}={5'b11111,5'b11111};
        endcase
    end
    
endmodule
