## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sysCLK -period 10.00 -waveform {0 5} [get_ports clk]


## Switches
set_property PACKAGE_PIN V17 [get_ports {DT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DT[0]}]
set_property PACKAGE_PIN V16 [get_ports {DT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DT[1]}]
set_property PACKAGE_PIN W16 [get_ports {DT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DT[2]}]
set_property PACKAGE_PIN W17 [get_ports {DT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DT[3]}]
set_property PACKAGE_PIN W15 [get_ports {DT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DT[4]}]
#set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {SW_START}]
set_property IOSTANDARD LVCMOS33 [get_ports {SW_START}]
#set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
set_property PACKAGE_PIN T3 [get_ports ID_SW]
set_property IOSTANDARD LVCMOS33 [get_ports ID_SW]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
set_property PACKAGE_PIN R3 [get_ports WS_MANOR]
set_property IOSTANDARD LVCMOS33 [get_ports WS_MANOR]
set_property PACKAGE_PIN W2 [get_ports WS_CELLAR]
set_property IOSTANDARD LVCMOS33 [get_ports WS_CELLAR]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
set_property PACKAGE_PIN T1 [get_ports ST]
set_property IOSTANDARD LVCMOS33 [get_ports ST]
set_property PACKAGE_PIN R2 [get_ports SS]
set_property IOSTANDARD LVCMOS33 [get_ports SS]


## LEDs
set_property PACKAGE_PIN U16 [get_ports {LED_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED_OUT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED_OUT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[3]}]
set_property PACKAGE_PIN W18 [get_ports {LED_OUT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED_OUT[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED_OUT[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED_OUT[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[7]}]
set_property PACKAGE_PIN V13 [get_ports {LED_OUT[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[8]}]
set_property PACKAGE_PIN V3 [get_ports {LED_OUT[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[9]}]
set_property PACKAGE_PIN W3 [get_ports {LED_OUT[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[10]}]
set_property PACKAGE_PIN U3 [get_ports {LED_OUT[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[11]}]
set_property PACKAGE_PIN P3 [get_ports {LED_OUT[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[12]}]
set_property PACKAGE_PIN N3 [get_ports {LED_OUT[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[13]}]
set_property PACKAGE_PIN P1 [get_ports {LED_OUT[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[14]}]
set_property PACKAGE_PIN L1 [get_ports {LED_OUT[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED_OUT[15]}]


##7 segment display
set_property PACKAGE_PIN W7 [get_ports CA]
set_property IOSTANDARD LVCMOS33 [get_ports CA]
set_property PACKAGE_PIN W6 [get_ports CB]
set_property IOSTANDARD LVCMOS33 [get_ports CB]
set_property PACKAGE_PIN U8 [get_ports CC]
set_property IOSTANDARD LVCMOS33 [get_ports CC]
set_property PACKAGE_PIN V8 [get_ports CD]
set_property IOSTANDARD LVCMOS33 [get_ports CD]
set_property PACKAGE_PIN U5 [get_ports CE]
set_property IOSTANDARD LVCMOS33 [get_ports CE]
set_property PACKAGE_PIN V5 [get_ports CF]
set_property IOSTANDARD LVCMOS33 [get_ports CF]
set_property PACKAGE_PIN U7 [get_ports CG]
set_property IOSTANDARD LVCMOS33 [get_ports CG]

set_property PACKAGE_PIN V7 [get_ports CW]
set_property IOSTANDARD LVCMOS33 [get_ports CW]

set_property PACKAGE_PIN U2 [get_ports AN0]
set_property IOSTANDARD LVCMOS33 [get_ports AN0]
set_property PACKAGE_PIN U4 [get_ports AN1]
set_property IOSTANDARD LVCMOS33 [get_ports AN1]
set_property PACKAGE_PIN V4 [get_ports AN2]
set_property IOSTANDARD LVCMOS33 [get_ports AN2]
set_property PACKAGE_PIN W4 [get_ports AN3]
set_property IOSTANDARD LVCMOS33 [get_ports AN3]


##Buttons
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN T18 [get_ports INCR]
set_property IOSTANDARD LVCMOS33 [get_ports INCR]
set_property PACKAGE_PIN W19 [get_ports CONF]
set_property IOSTANDARD LVCMOS33 [get_ports CONF]
set_property PACKAGE_PIN U17 [get_ports DECR]
set_property IOSTANDARD LVCMOS33 [get_ports DECR]
set_property PACKAGE_PIN T17 [get_ports RESTART]
set_property IOSTANDARD LVCMOS33 [get_ports RESTART]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

#create_clock -period 10.000 -name sysCLK -waveform {0.000 5.000} [get_ports clk]

#set_property PACKAGE_PIN B18 [get_ports RsRx]
	#set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
set_property PACKAGE_PIN A18 [get_ports TX]
	set_property IOSTANDARD LVCMOS33 [get_ports TX]