proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  debug::add_scope template.lib 1
  set_property design_mode GateLvl [current_fileset]
  set_property webtalk.parent_dir M:/student/inf3430/oblig2/oppg5/stopwatch/stopwatch.cache/wt [current_project]
  set_property parent.project_path M:/student/inf3430/oblig2/oppg5/stopwatch/stopwatch.xpr [current_project]
  set_property ip_repo_paths m:/student/inf3430/oblig2/oppg5/stopwatch/stopwatch.cache/ip [current_project]
  set_property ip_output_repo m:/student/inf3430/oblig2/oppg5/stopwatch/stopwatch.cache/ip [current_project]
  add_files -quiet M:/student/inf3430/oblig2/oppg5/stopwatch/stopwatch.runs/synth_1/clock.dcp
  read_xdc M:/student/inf3430/oblig2/oppg5/stopwatch/stopwatch.srcs/constrs_1/new/constraints.xdc
  link_design -top clock -part xc7z020clg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
}

start_step opt_design
set rc [catch {
  create_msg_db opt_design.pb
  catch {write_debug_probes -quiet -force debug_nets}
  opt_design 
  write_checkpoint -force clock_opt.dcp
  catch {report_drc -file clock_drc_opted.rpt}
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
}

start_step place_design
set rc [catch {
  create_msg_db place_design.pb
  catch {write_hwdef -file clock.hwdef}
  place_design 
  write_checkpoint -force clock_placed.dcp
  catch { report_io -file clock_io_placed.rpt }
  catch { report_utilization -file clock_utilization_placed.rpt -pb clock_utilization_placed.pb }
  catch { report_control_sets -verbose -file clock_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
}

start_step route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force clock_routed.dcp
  catch { report_drc -file clock_drc_routed.rpt -pb clock_drc_routed.pb }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file clock_timing_summary_routed.rpt -rpx clock_timing_summary_routed.rpx }
  catch { report_power -file clock_power_routed.rpt -pb clock_power_summary_routed.pb }
  catch { report_route_status -file clock_route_status.rpt -pb clock_route_status.pb }
  catch { report_clock_utilization -file clock_clock_utilization_routed.rpt }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
}

start_step write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  write_bitstream -force clock.bit 
  catch { write_sysdef -hwdef clock.hwdef -bitfile clock.bit -meminfo clock.mmi -ltxfile debug_nets.ltx -file clock.sysdef }
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
}

