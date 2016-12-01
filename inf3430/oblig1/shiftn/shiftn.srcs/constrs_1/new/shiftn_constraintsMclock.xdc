set_property IOSTANDARD LVCMOS33 [get_ports mclk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports Sdin]
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]
set_property PACKAGE_PIN U14 [get_ports Sdout]
set_property PACKAGE_PIN N15 [get_ports rst_n]
set_property PACKAGE_PIN M15 [get_ports Sdin]
set_property PACKAGE_PIN T18 [get_ports mclk]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_ports mclk]
set_property IOSTANDARD LCVMOS33 [get_ports -of_objects [get_iobanks 33]];

create_clock -period 20.000 -waveform {0.000 10.000} [get_ports mclk]

set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]]
