############## NET - IOSTANDARD #################################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLUP [current_design]
#############SPI Configurate Setting##############################
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
############## clock and reset define##############################
create_clock -period 20.000 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN R4 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property PACKAGE_PIN U2 [get_ports rst_n]

#####################HDMI_IN_A#######################################
create_clock -period 6.000 -name clk_hdmi_in_p -waveform {0.000 3.000}
set_property PACKAGE_PIN D22 [get_ports hdmi_ddc_scl_io]
set_property PACKAGE_PIN D21 [get_ports hdmi_ddc_sda_io]
set_property PACKAGE_PIN E22 [get_ports hdmi_in_hpd]
set_property PACKAGE_PIN C18 [get_ports clk_hdmi_in_p]
set_property PACKAGE_PIN C22 [get_ports {data_hdmi_in_p[0]}]
set_property PACKAGE_PIN B21 [get_ports {data_hdmi_in_p[1]}]
set_property PACKAGE_PIN B20 [get_ports {data_hdmi_in_p[2]}]
set_property PACKAGE_PIN E21 [get_ports hdmi_in_oen]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ddc_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_ddc_sda_io]
set_property IOSTANDARD TMDS_33 [get_ports clk_hdmi_in_n]
set_property IOSTANDARD TMDS_33 [get_ports clk_hdmi_in_p]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_in_n[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_in_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_in_n[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_in_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_in_n[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_in_p[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_in_oen]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_in_hpd]
######################HDMI_OUT_B#######################################
set_property PACKAGE_PIN B17 [get_ports clk_hdmi_out_p]
set_property PACKAGE_PIN A18 [get_ports {data_hdmi_out_p[0]}]
set_property PACKAGE_PIN A15 [get_ports {data_hdmi_out_p[1]}]
set_property PACKAGE_PIN A13 [get_ports {data_hdmi_out_p[2]}]
set_property PACKAGE_PIN C20 [get_ports hdmi_out_oen]
set_property IOSTANDARD TMDS_33 [get_ports clk_hdmi_out_n]
set_property IOSTANDARD TMDS_33 [get_ports clk_hdmi_out_p]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_out_n[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_out_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_out_n[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_out_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_out_n[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {data_hdmi_out_p[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_out_oen]


set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {bus_DATA[0]}]
set_property PACKAGE_PIN J20 [get_ports {bus_DATA[15]}]
set_property PACKAGE_PIN G20 [get_ports {bus_DATA[14]}]
set_property PACKAGE_PIN H20 [get_ports {bus_DATA[13]}]
set_property PACKAGE_PIN L18 [get_ports {bus_DATA[12]}]
set_property PACKAGE_PIN M18 [get_ports {bus_DATA[11]}]
set_property PACKAGE_PIN F21 [get_ports {bus_DATA[10]}]
set_property PACKAGE_PIN F18 [get_ports {bus_DATA[9]}]
set_property PACKAGE_PIN E17 [get_ports {bus_DATA[8]}]
set_property PACKAGE_PIN D17 [get_ports {bus_DATA[7]}]
set_property PACKAGE_PIN N22 [get_ports {bus_DATA[6]}]
set_property PACKAGE_PIN M22 [get_ports {bus_DATA[5]}]
set_property PACKAGE_PIN M21 [get_ports {bus_DATA[4]}]
set_property PACKAGE_PIN L21 [get_ports {bus_DATA[3]}]
set_property PACKAGE_PIN K22 [get_ports {bus_DATA[2]}]
set_property PACKAGE_PIN K21 [get_ports {bus_DATA[1]}]
set_property PACKAGE_PIN J22 [get_ports {bus_DATA[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports bus_CS]
set_property IOSTANDARD LVCMOS33 [get_ports bus_DC]
set_property IOSTANDARD LVCMOS33 [get_ports bus_RD]
set_property IOSTANDARD LVCMOS33 [get_ports bus_RST]
set_property IOSTANDARD LVCMOS33 [get_ports bus_WR]

set_property PACKAGE_PIN D19 [get_ports bus_CS]
set_property PACKAGE_PIN E19 [get_ports bus_DC]
set_property PACKAGE_PIN G22 [get_ports bus_RD]
set_property PACKAGE_PIN H22 [get_ports bus_RST]
set_property PACKAGE_PIN G21 [get_ports bus_WR]






























