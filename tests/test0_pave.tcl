#! /usr/bin/env tclsh

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
# ___________________________ Initialize variables _____________________________ #

# to get TCLLIBPATH variable when run from tclkit
if {[info exists ::env(TCLLIBPATH)]} {lappend ::auto_path {*}$::env(TCLLIBPATH)}

set ::testdirname [file normalize [file dirname [info script]]]
set ::pavedirname [file normalize [file join $::testdirname .. .. apave]]
cd $::testdirname
set ::test2dirs [list $::pavedirname $::testdirname/.. $::testdirname]
lappend ::auto_path {*}$::test2dirs

package require apave

# ________________________ Test by itself _________________________ #

# This test 1 demonstrates how easily the standard dialog "Search & Replace"
# can be created by means of the pave.

apave::initWM
apave::APave create pave
set win .win
pave makeWindow $win.fra "Find and Replace"
set v1 [set v2 1]
set c1 [set c2 [set c3 0]]
set en1 [set en2 ""]
pave paveWindow $win.fra {
  {lab1 - - 1 1    {-st es}  {-t "Find: "}}
  {ent1 lab1 L 1 9 {-st wes} {-tvar ::en1}}
  {lab2 lab1 T 1 1 {-st es}  {-t "Replace: "}}
  {ent2 lab2 L 1 9 {-st wes} {-tvar ::en2}}
  {labm lab2 T 1 1 {-st es} {-t "Match: "}}
  {radA labm L 1 1 {-st ws} {-t "Exact" -var ::v1 -value 1}}
  {radB radA L 1 1 {-st ws} {-t "Glob" -var ::v1 -value 2}}
  {radC radB L 1 1 {-st es} {-t "RE  " -var ::v1 -value 3}}
  {h_2 radC L 1 2  {-cw 1}}
  {h_3 labm T 1 9  {-st es -rw 1}}
  {seh  h_3 T 1 9  {-st ews}}
  {chb1 seh  T 1 2 {-st w} {-t "Match whole word only" -var ::c1}}
  {chb2 chb1 T 1 2 {-st w} {-t "Match case"  -var ::c2}}
  {chb3 chb2 T 1 2 {-st w} {-t "Wrap around" -var ::c3}}
  {sev1 chb1 L 3 1 }
  {lab3 sev1 L 1 2 {-st w} {-t "Direction:"}}
  {rad1 lab3 T 1 1 {-st we} {-t "Down" -var ::v2 -value 1}}
  {rad2 rad1 L 1 1 {-st we} {-t "Up"   -var ::v2 -value 2}}
  {sev2 ent1 L 8 1 }
  {but1 sev2 L 1 1 {-st we} {-t "Find" -com "::pave res $win 1"}}
  {but2 but1 T 1 1 {-st we} {-t "Find All" -com "::pave res $win 2"}}
  {lab_ but2 T 2 1}
  {but3 lab_ T 1 1 {-st we} {-t "Replace"  -com "::pave res $win 3"}}
  {but4 but3 T 1 1 {-st nwe} {-t "Replace All" -com "::pave res $win 4"}}
  {seh3 but4 T 1 1 {-st ewn}}
  {but5 seh3 T 3 1 {-st we} {-t "Close" -com "::pave res $win 0"}}
}
set res [pave showModal $win -focus $win.fra.ent1 -geometry +200+200]

apave::APaveDialog create pdlg
pdlg ok info Results " \
  Entry1: $en1 \n \
  Entry2: $en2 \n \
  E/G/R: $v1 \n \
  ______________________________      \n \
  \n \
  CheckBox1: $c1 \n \
  CheckBox2: $c2 \n \
  CheckBox3: $c3 \n \
  ______________________________      \n \
  \n \
  Direction: $v2 \n \
  ______________________________      \n \
  \n \
  Button chosen: $res \n \
  "
pdlg destroy

pave destroy
destroy $win

exit

