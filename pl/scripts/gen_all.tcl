# ------------------------------------------------------------------------------------
# Argument parser (cli options)
# ------------------------------------------------------------------------------------
package require cmdline

set options {
   {gui                "Launch in gui."                      }
   {board.arg "z7-10"  "Select part (z7-10|z7-20). Default:" }
   {synth              "Run step synth."                     }
   {impl               "Run step impl."                      }
}
# TODO: update usage to be better
set usage ": build \[-gui] [-board ARG] [-synth] [-impl]\noptions:"
array set params [::cmdline::getoptions argv $options $usage]

# Print for sanity
parray params

# Setup Board
switch $params(board) {
   z7-10 { set board digilentinc.com:xilinx_board_store:zybo-z7-10:* }
   z7-20 { set board digilentinc.com:xilinx_board_store:zybo-z7-20:* }
   default { send_msg "BuildScript-0" "ERROR" "not a suported board" }
}

# Make sure boards are installed
xhub::install [xhub::get_xitems $board ]
xhub::update  [xhub::get_xitems $board ]

if $params(gui) {
   start_gui
}


# ------------------------------------------------------------------------------------
# Create project
# ------------------------------------------------------------------------------------
set ROOT [file normalize [file join [file dirname [info script]] .. ]]
set outputdir [file join "$ROOT" vivado_files]
file mkdir $outputdir
create_project acoustic_warfare $outputdir -force


# Add sources to the project
read_vhdl -vhdl_2008 [file join "$ROOT" src *.vhd]
read_vhdl -vhdl_2008 [file join "$ROOT" src * *.vhd]
add_files -fileset constrs_1 [file join "$ROOT" src constraint.xdc]


# Set Properties
set_property board_part $board     [current_project]
set_property target_language VHDL  [current_project]
set_property file_type {VHDL 2008} [get_files  *.vhd]

# Import Block Design
source [file normalize [file join $ROOT "scripts"  "bd.tcl" ]]
# FIXME: Validate
make_wrapper -inst_template [get_files [get_designs].bd ]


if params(synth) {
   # TODO: Synth commands
}

if params(impl) {
   # TODO: Implementaion commands
}
