`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2020 09:44:06
// Design Name: 
// Module Name: state_machine
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


module state_machine(
input wire ck,reset,
input wire insert,remove,flush,test, 
output wire chipsel,write_en,clrWp,clrRp,incWp,incRp,RpNWp, 
output reg empty,full); 

parameter EMPTY=3'b000, WRITE=3'b001, READ=3'b010, FULL=3'b011, FLUSH=3'b100, IDLE=3'b101; 

reg [2:0] state,state_nxt; 
reg [6:0] varout; 

//STATE LOGIC
always @(posedge ck or posedge reset) 
if(reset) state<=EMPTY; 
else state<=state_nxt; 

//NEXT STATE LOGIC
always@(state, flush, insert, remove, test) 
case(state) 
EMPTY: if (flush==1'b1) state_nxt=FLUSH; 
       else if (insert==1'b1) state_nxt=WRITE;
            else state_nxt=EMPTY;
WRITE: if (flush==1'b1) state_nxt=FLUSH; 
       else if (remove==1'b1) state_nxt=READ;   
            else if (test==1'b1) state_nxt=FULL; 
                  else if (insert==1'b1) state_nxt=WRITE; 
                        else state_nxt=IDLE;
READ: if (flush==1'b1) state_nxt=FLUSH; 
       else if (insert==1'b1) state_nxt=WRITE;   
            else if (test==1'b1) state_nxt=EMPTY; 
                    else if (remove==1'b1) state_nxt=READ; 
                        else state_nxt=IDLE;
FULL: if (flush==1'b1) state_nxt=FLUSH; 
       else if (remove==1'b1) state_nxt=READ; 
            else state_nxt=FULL;
FLUSH: if (flush==1'b1) state_nxt=FLUSH; 
       else if (insert==1'b1) state_nxt=WRITE;
            else state_nxt=EMPTY;
IDLE: if (flush==1'b1) state_nxt=FLUSH;
        else if (remove==1'b1) state_nxt=READ; 
            else if (insert==1'b1) state_nxt=WRITE;
                else state_nxt=IDLE; 
default: state_nxt=IDLE;
endcase

//OUTPUT LOGIC
assign {chipsel,write_en,clrWp,clrRp,incWp,incRp,RpNWp}=varout; 
always@(state,flush,insert,remove,test) 
case(state) 
EMPTY: 
if (flush==1'b1) varout={1'b0,1'bx,1'b1,1'b1,1'bx,1'bx,1'bx}; 
       else if (insert==1'b1) varout={1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0}; 
            else varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
WRITE: 
if (flush==1'b1) varout={1'b0,1'bx,1'b1,1'b1,1'bx,1'bx,1'bx};  
       else if (remove==1'b1) varout={1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}; 
            else if (test==1'b1) varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
                  else if (insert==1'b1) varout={1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0}; 
                        else varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx};               
READ: 
if (flush==1'b1) varout={1'b0,1'bx,1'b1,1'b1,1'bx,1'bx,1'bx}; 
       else if (insert==1'b1) varout={1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0};   
            else if (test==1'b1) varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
                  else if (remove==1'b1)  varout={1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}; 
                        else varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
FULL: 
if (flush==1'b1) varout={1'b0,1'bx,1'b1,1'b1,1'bx,1'bx,1'bx}; 
       else if (remove==1'b1) varout={1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}; 
            else varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
FLUSH: 
if (flush==1'b1) varout={1'b0,1'bx,1'b1,1'b1,1'bx,1'bx,1'bx}; 
else if (insert==1'b1) varout={1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0}; 
else varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
IDLE: 
if (flush==1'b1) varout={1'b0,1'bx,1'b1,1'b1,1'bx,1'bx,1'bx}; 
        else if (remove==1'b1) varout={1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1}; 
            else if (insert==1'b1) varout={1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0};  
                 else varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
default: varout={1'b0,1'bx,1'b0,1'b0,1'b0,1'b0,1'bx}; 
endcase

always@(state) 
case(state) 
EMPTY: empty=1'b1;
WRITE: empty=1'b0;            
READ: empty=1'b0;  
FULL: empty=1'b0;  
FLUSH: empty=1'b1;
IDLE: empty=1'b0;  
default: empty=1'b0;
endcase

always@(state,test) 
case(state) 
EMPTY: full=1'b0;
WRITE: if (test==1'b1) full=1'b1;
       else full=1'b0;            
READ: full=1'b0;  
FULL: full=1'b1;   
FLUSH: full=1'b0;
IDLE: full=1'b0;  
default: full=1'b0;
endcase

endmodule