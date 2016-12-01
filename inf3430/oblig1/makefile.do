vsim -voptargs=+acc work.test_first
add wave -position insertpoint  \
sim:/test_first/MCLK \
sim:/test_first/RESET \
sim:/test_first/LOAD \
sim:/test_first/INP \
sim:/test_first/COUNT \
sim:/test_first/MAX_COUNT \
sim:/test_first/Half_Period