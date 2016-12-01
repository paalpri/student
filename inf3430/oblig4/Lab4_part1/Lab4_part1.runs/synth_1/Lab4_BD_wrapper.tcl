# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {Common-41} -limit 4294967295
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir M:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.cache/wt [current_project]
set_property parent.project_path M:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
add_files M:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/Lab4_BD.bd
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_processing_system7_0_0/Lab4_BD_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_axi_gpio_0_0/Lab4_BD_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_axi_gpio_0_0/Lab4_BD_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_axi_gpio_0_0/Lab4_BD_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_rst_processing_system7_0_100M_0/Lab4_BD_rst_processing_system7_0_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_rst_processing_system7_0_100M_0/Lab4_BD_rst_processing_system7_0_100M_0.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_rst_processing_system7_0_100M_0/Lab4_BD_rst_processing_system7_0_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all m:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/ip/Lab4_BD_auto_pc_0/Lab4_BD_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all M:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/Lab4_BD_ooc.xdc]
set_property is_locked true [get_files M:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/Lab4_BD.bd]

read_vhdl -library xil_defaultlib M:/student/inf3430/oblig4/Lab4_part1/Lab4_part1.srcs/sources_1/bd/Lab4_BD/hdl/Lab4_BD_wrapper.vhd
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
synth_design -top Lab4_BD_wrapper -part xc7z020clg484-1
write_checkpoint -noxdef Lab4_BD_wrapper.dcp
catch { report_utilization -file Lab4_BD_wrapper_utilization_synth.rpt -pb Lab4_BD_wrapper_utilization_synth.pb }
