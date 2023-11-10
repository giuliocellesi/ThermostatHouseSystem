`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2023 14:35:14
// Design Name: 
// Module Name: Top_Thermostat
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


module Top_Thermostat#(parameter SIZE_FIFO = 5)(
input wire clk,rst,
input wire DECR,INCR,
input wire CONF,SW_START,SS,ST,WS_MANOR, WS_CELLAR, 
input wire ID_SW, RESTART, //INPUT NUOVI
input wire [4:0] DT,
output wire AN0,AN1,AN2,AN3,CA,CB,CC,CD,CE,CF,CG,CW,TX,
output wire[15:0] LED_OUT
    );
    
    wire hit_read, hit_write, WS;
    wire [19:0] DATA;
    wire [4:0] DTF;
    wire [5:0] RTR;
    
    wire SW_START_I, WS_MANOR_I, WS_CELLAR_I, RESTART_I;
    
    wire read_end, insert, empty_FIFO, consume;
    wire [19:0] data_out, data_to_UART;
    
    SYSTEM_CORE_TOP_MODULE SCore(.clk(clk), .rst(rst), .DECR(DECR), .INCR(INCR), .CONF(CONF), .SW_START(SW_START_I), .SS(SS), .ST(ST), .WS_MANOR(WS_MANOR_I),
    .WS_CELLAR(WS_CELLAR_I), .ID_SW(ID_SW), .RESTART(RESTART_I), .DT(DT), .LED_OUT(LED_OUT),.hit_write(hit_write), .hit_read(hit_read), .DATA(DATA),
    .RTR(RTR), .WS(WS), .DTF(DTF));
    
    Top_log_screen log(.clk(clk), .rst(rst), .start(read_end), .empty_FIFO(empty_FIFO), .data_in(data_to_UART), .consume(consume), .TX(TX));
    
    wire o_RX_DV_master,o_RX_DV_S_btns,o_RX_DV_MANOR,i_TX_DV_MANOR,o_RX_DV_CELLAR,i_TX_DV_CELLAR,o_RX_DV_DISPLAY;
    wire [3:0] o_RX_Byte_S_btns,data_to_send_btns;
    wire [19:0] data_to_send,o_RX_Byte_MANOR,i_TX_Byte_MANOR,i_TX_Byte_CELLAR,o_RX_Byte_CELLAR,o_RX_Byte_DISPLAY;
    wire [1:0] slaveSelector;
    
    //comms dispatcher contenente Master_fifo_display, slave_buttons e auxiliary fifo
    Comms_Dispatcher#(5) CommsDispatcher (.clk(clk), .rst(rst), .rd(hit_read), .we(hit_write), .data_in(DATA), .DTF(DTF), .RTR(RTR), .WS(WS), .tx_ready(o_RX_DV_master), .arrived(o_RX_DV_S_btns), 
    .data_received(o_RX_Byte_S_btns), .consume(consume), .data_to_FIFO(data_out), .read_end(read_end), .data_to_send(data_to_send), .ss(slaveSelector), 
    .start_out(SW_START_I), .restart_out(RESTART_I), .windows_out({WS_MANOR_I, WS_CELLAR_I}), .empty_FIFO(empty_FIFO), .data_to_UART(data_to_UART));
    
    SPI_top #(.DATA_SIZE(20), .SPI_MODE(3), .SPI_CLK_DIVIDER(8), .DATA_SIZE_B(4)) SPI_TOP(.clk(clk), .rst(rst), .slave_selector(slaveSelector) , 
    .i_TX_Byte_M(data_to_send), .i_TX_Byte_DISPLAY(20'd0), 
    .i_TX_Byte_MANOR(i_TX_Byte_MANOR), .i_TX_Byte_CELLAR(i_TX_Byte_CELLAR), 
    .i_TX_DV_M(1'b1), .i_TX_DV_DISPLAY(1'b0), .i_TX_DV_MANOR(i_TX_DV_MANOR), 
    .i_TX_DV_CELLAR(i_TX_DV_CELLAR), .o_RX_DV_M(o_RX_DV_master), .o_RX_DV_MANOR(o_RX_DV_MANOR), 
    .o_RX_DV_CELLAR(o_RX_DV_CELLAR), .o_RX_DV_DISPLAY(o_RX_DV_DISPLAY), .o_RX_Byte_MANOR(o_RX_Byte_MANOR), 
    .o_RX_Byte_CELLAR(o_RX_Byte_CELLAR), .o_RX_Byte_DISPLAY(o_RX_Byte_DISPLAY), 
    .o_TX_Ready_M(), .o_RX_Byte_M(data_out), 
    .i_TX_Byte_M_btns(data_to_send_btns), .i_TX_Byte_S_btns(4'd0), .i_TX_DV_M_btns(1'b1), .i_TX_DV_S_btns(1'b0), .o_TX_Ready_M_btns(),
    .o_RX_DV_M_btns(), .o_RX_Byte_M_btns(), .o_RX_DV_S_btns(o_RX_DV_S_btns), .o_RX_Byte_S_btns(o_RX_Byte_S_btns));  
    
    //periferica master buttons
    Master_buttons M(.clk(clk),.rst(rst),.start(SW_START),.restart(RESTART), .windows({WS_MANOR, WS_CELLAR}), .data_to_send(data_to_send_btns));
    
    //periferiche fifo e display
    top_slave_fifo #(.SIZE_FIFO(5)) MANOR(.clk(clk), .rst(rst), .o_RX_DV(o_RX_DV_MANOR), .i_TX_DV(i_TX_DV_MANOR), .o_RX_Byte(o_RX_Byte_MANOR), .i_TX_Byte(i_TX_Byte_MANOR));
    
    top_slave_fifo #(.SIZE_FIFO(5)) CELLAR(.clk(clk), .rst(rst), .o_RX_DV(o_RX_DV_CELLAR), .i_TX_DV(i_TX_DV_CELLAR), .o_RX_Byte(o_RX_Byte_CELLAR), .i_TX_Byte(i_TX_Byte_CELLAR));
   
    top_slave_7SD DISPLAY(.clk(clk), .rst(rst), .o_RX_DV(o_RX_DV_DISPLAY), .o_RX_BYTE(o_RX_Byte_DISPLAY), .AN0(AN0), .AN1(AN1), .AN2(AN2), .AN3(AN3), .CA(CA), .CB(CB), .CC(CC), .CD(CD), .CE(CE), .CF(CF), .CG(CG), .CW(CW)); 
endmodule
