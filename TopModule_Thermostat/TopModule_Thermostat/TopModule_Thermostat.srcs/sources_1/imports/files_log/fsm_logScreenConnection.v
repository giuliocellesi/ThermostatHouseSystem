`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Giulio Cellesi
// 
// Create Date: 24.03.2023 10:29:45
// Design Name: 
// Module Name: fsm
// 
//////////////////////////////////////////////////////////////////////////////////


module fsm_logScreenConnection(
input wire clk, rst, start, stop, done, available, hit,
output reg consume, inc, send, update, en_timer
    ); 

parameter IDLE=3'b000, READ = 3'b001, WAIT = 3'b010, SEND = 3'b011, CHECK = 3'b101;
reg [2:0] state, statenxt;

always @(posedge clk, posedge rst)
begin
    if(rst) state <= 2'd0;
    else state <= statenxt;
end

always @(state,start, stop, done, available, hit)
begin
    case(state)
    IDLE: 
    begin
        if(start) statenxt = READ;
        else statenxt = IDLE;
    end
    READ:
    begin
        if(hit) statenxt = WAIT;
        else statenxt = READ;
    end
    WAIT:
    begin
        if(available == 1'b0) statenxt = WAIT;
        else if(done) statenxt = CHECK;
        else statenxt = SEND;
    end
    SEND:
    begin
       statenxt = WAIT;
    end  
    CHECK:
    begin
        if(stop) statenxt = IDLE;
        else statenxt = READ;
    end
    default: statenxt = IDLE;
    endcase
end

always @(state)
begin
    case(state)
    IDLE: begin  send=1'b0; en_timer=1'b0; end
    READ: begin  send=1'b0; en_timer=1'b1; end
    WAIT: begin  send=1'b0; en_timer=1'b0;  end
    SEND: begin  send=1'b1; en_timer=1'b0; end
    default: begin  send=1'b0; en_timer=1'b0; end
    endcase
end

always @(state, available, hit, start, stop, done)
begin
    case(state)
    IDLE: begin
        if(start) begin consume = 1'b1; update = 1'b0; inc=1'b0; end
        else begin consume = 1'b0; update = 1'b0; inc=1'b0; end
    end
    READ: begin
        if(hit == 1'b1) begin update = 1'b1; consume = 1'b0; inc=1'b0; end
        else begin update = 1'b0; consume = 1'b0; inc=1'b0; end
    end
    WAIT:
        begin
              if(available == 1'b0) begin update = 1'b0; consume = 1'b0; inc=1'b0; end
        else if(done) begin update = 1'b0; consume = 1'b0; inc=1'b1; end
        else begin update = 1'b0; consume = 1'b0; inc=1'b1; end
    end
    CHECK:
    begin
        if(stop)  begin consume = 1'b0; update = 1'b0; inc=1'b0; end
        else  begin consume = 1'b1; update = 1'b0; inc=1'b0; end
    end
    default: begin inc = 1'b0; consume = 1'b0; update = 1'b0; end
    endcase
end
endmodule