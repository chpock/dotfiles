
if { !$::tcl_interactive } return

puts "Tcl $tcl_patchLevel"

if { [file exists [file join $::env(IAM_HOME) tools tcl TclReadLine]] } {

    lappend auto_path [file join $::env(IAM_HOME) tools tcl TclReadLine]

    package require TclReadLine

    set ::TclReadLine::HISTFILE     [file join $::env(IAM_HOME) tclline_history]
    set ::TclReadLine::HISTORY_SIZE 99999

    TclReadLine::interact

}

