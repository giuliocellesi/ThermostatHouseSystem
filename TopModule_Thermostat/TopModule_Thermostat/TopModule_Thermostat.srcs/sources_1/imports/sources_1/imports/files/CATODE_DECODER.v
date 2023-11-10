`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Gruppo 1
// Engineer: Alessandro Monni
// 
// Create Date: 23.03.2023 15:02:59
// Design Name: 
// Module Name: CATODE_DECODER
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


module CATODE_DECODER(
input wire [4:0] SEG,
output reg CA,CB,CC,CD,CE,CF,CG
    );
    
    always@(SEG)
        case(SEG)
            5'd0: {CA,CB,CC,CD,CE,CF,CG} = 7'b0000001; //0
            5'd1: {CA,CB,CC,CD,CE,CF,CG} = 7'b1001111; //1
            5'd2: {CA,CB,CC,CD,CE,CF,CG} = 7'b0010010; //2
            5'd3: {CA,CB,CC,CD,CE,CF,CG} = 7'b0000110; //3
            5'd4: {CA,CB,CC,CD,CE,CF,CG} = 7'b1001100; //4
            5'd5: {CA,CB,CC,CD,CE,CF,CG} = 7'b0100100; //5
            5'd6: {CA,CB,CC,CD,CE,CF,CG} = 7'b0100000; //6
            5'd7: {CA,CB,CC,CD,CE,CF,CG} = 7'b0001111; //7
            5'd8: {CA,CB,CC,CD,CE,CF,CG} = 7'b0000000; //8
            5'd9: {CA,CB,CC,CD,CE,CF,CG} = 7'b0000100; //9
            5'd10: {CA,CB,CC,CD,CE,CF,CG} = 7'b0001000; //a
            5'd11: {CA,CB,CC,CD,CE,CF,CG} = 7'b1100000; //b
            5'd12: {CA,CB,CC,CD,CE,CF,CG} = 7'b0110001; //c
            5'd13: {CA,CB,CC,CD,CE,CF,CG} = 7'b1000010; //d
            5'd14: {CA,CB,CC,CD,CE,CF,CG} = 7'b0110000; //e
            5'd15: {CA,CB,CC,CD,CE,CF,CG} = 7'b0111000; //f
            5'd16: {CA,CB,CC,CD,CE,CF,CG} = 7'b0100000; //g
            5'd17: {CA,CB,CC,CD,CE,CF,CG} = 7'b1001000; //h
            5'd18: {CA,CB,CC,CD,CE,CF,CG} = 7'b1111001; //i
            5'd19: {CA,CB,CC,CD,CE,CF,CG} = 7'b1110001; //l
            5'd20: {CA,CB,CC,CD,CE,CF,CG} = 7'b0001001; //m
            5'd21: {CA,CB,CC,CD,CE,CF,CG} = 7'b1101010; //n
            5'd22: {CA,CB,CC,CD,CE,CF,CG} = 7'b0000001; //o
            5'd23: {CA,CB,CC,CD,CE,CF,CG} = 7'b0011000; //p
            5'd24: {CA,CB,CC,CD,CE,CF,CG} = 7'b0001100; //q
            5'd25: {CA,CB,CC,CD,CE,CF,CG} = 7'b1111000; //r
            5'd26: {CA,CB,CC,CD,CE,CF,CG} = 7'b0100100; //s
            5'd27: {CA,CB,CC,CD,CE,CF,CG} = 7'b0111001; //t
            5'd28: {CA,CB,CC,CD,CE,CF,CG} = 7'b1000001; //u
            5'd29: {CA,CB,CC,CD,CE,CF,CG} = 7'b1100011; //v
            5'd30: {CA,CB,CC,CD,CE,CF,CG} = 7'b0010010; //z
            5'd31: {CA,CB,CC,CD,CE,CF,CG} = 7'b1111110; //trattino
            default: {CA,CB,CC,CD,CE,CF,CG} = 7'b1111111; //tutto spento
        endcase
        
endmodule
