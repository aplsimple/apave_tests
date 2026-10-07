#! /usr/bin/env tclsh

###########################################################################
#
# Tests for 'eval' and 'apave::Eval'.
#
###########################################################################

package require Tk

# ______________________ Remove installed (perhaps) packages ____________________ #

foreach _ {apave baltip bartabs hl_tcl ttk::theme::awlight ttk::theme::awdark awthemes} {
  set __ [package version $_]
  catch {
    package forget $_
    namespace delete ::$_
    puts "alited: clearing $_ $__"
  }
  unset __
}
# ___________________________ Variables _____________________________ #

# to get TCLLIBPATH variable when run from tclkit
if {[info exists ::env(TCLLIBPATH)]} {lappend ::auto_path {*}$::env(TCLLIBPATH)}

set ::testdirname [file normalize [file dirname [info script]]]
set ::pavedirname [file normalize [file join $::testdirname .. .. apave]]
cd $::testdirname
set ::test2dirs [list $::pavedirname $::testdirname/.. $::testdirname]
lappend ::auto_path {*}$::test2dirs

package require apave

# ________________________ Tests _________________________ #

proc p1 {com} {
  set src {
    # code of nonsense, just for testing
    set a 123
    set b 3.45
    for {set i 0} {$i < $a} {incr i} {
      if {$i > 5} {incr i 2}
      expr {$a * $i / $b}
    }
  }
  {*}$com $src
}
#_______________________

proc p2 {} {
  set src {
    # code of nonsense, just for testing
    set a 123
    set b 3.45
    foreach i {1 2 3 4 5 6 7 8 9} {
      if {$i > 5} {incr i 2}
      expr {$a * $i / $b}
    }
  }
  eval $src
}
#_______________________

proc p3 {} {
  set src {
    # code of nonsense, just for testing
    set a 123
    set b 3.45
    foreach i {1 2 3 4 5 6 7 8 9} {
      if {$i > 5} {incr i 2}
      expr {$a * $i / $b}
    }
  }
  apave::Eval $src
}

# ________________________ Run tests _________________________ #


set count 20000
puts a:\ [time {p1 eval} $count]
puts b:\ [time {p1 ::apave::Eval} $count]\n

puts c:\ [time {p1 eval} $count]
puts d:\ [time {p1 eval} $count]\n

puts e:\ [time {p1 apave::Eval} $count]
puts f:\ [time {p1 apave::Eval} $count]\n

puts g:\ [time {p2} $count]
puts h:\ [time {p3} $count]\n

#_______________________

exit
