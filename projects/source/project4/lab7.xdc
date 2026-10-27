## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clock]							
	set_property IOSTANDARD LVCMOS33 [get_ports clock]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clock]
 
## Switches
set_property PACKAGE_PIN V17 [get_ports {enable}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enable}]
set_property PACKAGE_PIN V16 [get_ports {get_ports {wave_sel[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {get_ports {wave_sel[0]}]
set_property PACKAGE_PIN W16 [get_ports {get_ports {wave_sel[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {wave_sel[1]}}]	
	
##Buttons
set_property PACKAGE_PIN U18 [get_ports reset]						
	set_property IOSTANDARD LVCMOS33 [get_ports reset]

 


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {JA[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {JA[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[1]}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {JA[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[2]}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {JA[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]
##Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {JA[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[4]}]
##Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {JA[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[5]}]
##Sch name = JA9
set_property PACKAGE_PIN H2 [get_ports {JA[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[6]}]
##Sch name = JA10
set_property PACKAGE_PIN G3 [get_ports {JA[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[7]}]


