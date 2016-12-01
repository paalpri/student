# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir M:/student/inf3430/oblig1/cookbook/cookbook.cache/wt [current_project]
set_property parent.project_path M:/student/inf3430/oblig1/cookbook/cookbook.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
read_vhdl -library xil_defaultlib M:/student/inf3430/oblig1/src/first.vhd
read_xdc M:/student/inf3430/oblig1/cookbook/cookbook.srcs/constrs_1/new/constraints.xdc
set_property used_in_implementation false [get_files M:/student/inf3430/oblig1/cookbook/cookbook.srcs/constrs_1/new/constraints.xdc]

synth_design -top FIRST -part xc7z020clg484-1
write_checkpoint -noxdef FIRST.dcp
catch { report_utilization -file FIRST_utilization_synth.rpt -pb FIRST_utilization_synth.pb }