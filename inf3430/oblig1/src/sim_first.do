vsim -novopt work.test_first
add wave sim:/test_first/mclk
add wave sim:/test_first/reset
add wave sim:/test_first/load
add wave sim:/test_first/inp
add wave sim:/test_first/count
add wave sim:/test_first/max_count
run 1 us
