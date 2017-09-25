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

set_msg_config  -ruleid {2}  -id {filemgmt 20-1318}  -string {{WARNING: [filemgmt 20-1318] Duplicate Design Unit 'SUM(bhd)' found in library 'xil_defaultlib'
Duplicate found at line 14 of file C:/Users/Diego/Desktop/Arqui/Proyecto/Proyecto/Extras/Proyecto Base/Proyecto Base.srcs/sources_1/imports/new/operadores.vhd
	(Active) Duplicate found at line 16 of file C:/Users/Diego/Desktop/Arqui/Proyecto/Proyecto/Extras/Proyecto Base/Proyecto Base.srcs/sources_1/imports/new/resta.vhd}}  -suppress 
set_msg_config  -ruleid {3}  -id {Common 17-349}  -string {{INFO: [Common 17-349] Got license for feature 'Synthesis' and/or device 'xc7a35t-cpg236'}}  -suppress 
set_msg_config  -ruleid {4}  -id {HDL 9-849}  -string {{CRITICAL WARNING: [HDL 9-849] Syntax error : file ended before end of clause. [C:/Users/Diego/Desktop/Arqui/Proyecto/Proyecto/Extras/Proyecto Base/Proyecto Base.srcs/sources_1/imports/new/operadores.vhd:93]}}  -suppress 
set_msg_config  -ruleid {5}  -id {Synth 8-2715}  -string {{ERROR: [Synth 8-2715] syntax error near : [C:/Users/Diego/Desktop/Arqui/Proyecto/Proyecto/Extras/Proyecto Base/Proyecto Base.srcs/sources_1/imports/new/Clock_Divider.vhd:18]}}  -suppress 
set_msg_config  -ruleid {6}  -id {Synth 8-1031}  -string {{ERROR: [Synth 8-1031] slow_max is not declared [C:/Users/Diego/Desktop/Arqui/Proyecto/Proyecto/Extras/Proyecto Base/Proyecto Base.srcs/sources_1/imports/new/Clock_Divider.vhd:30]}}  -suppress 
set_msg_config  -ruleid {7}  -id {Synth 8-2810}  -string {{INFO: [Synth 8-2810] unit behavioral ignored due to previous errors [C:/Users/Diego/Desktop/Arqui/Proyecto/Proyecto/Extras/Proyecto Base/Proyecto Base.srcs/sources_1/imports/new/Clock_Divider.vhd:13]}}  -suppress 
set_msg_config  -ruleid {8}  -id {Common 17-69}  -string {{ERROR: [Common 17-69] Command failed: Synthesis failed - please see the console or run log file for details}}  -suppress 
set_msg_config  -ruleid {9}  -id {Common 17-206}  -string {{INFO: [Common 17-206] Exiting Vivado at Sat Sep  2 01:27:29 2017...}}  -suppress 

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_param xicom.use_bs_reader 1
  open_checkpoint Basys3_routed.dcp
  set_property webtalk.parent_dir {C:/Users/Diego/Desktop/RepoArqui/2017-2-G06/proyecto/Proyecto Base/Proyecto Base.cache/wt} [current_project]
  catch { write_mem_info -force Basys3.mmi }
  write_bitstream -force Basys3.bit -bin_file
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx Basys3.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

