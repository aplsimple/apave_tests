#! /usr/bin/env tclsh

# ________________________ Description _________________________ #
#
# These tests show how to
#   - add a new widget
#   - enlarge an existing widget by a cell
#
# 1. We have to add A2 widget at the right of A widget.
#    By the pave it is rather trivial task. We should:
#     - insert a description of A2 widget between A's and B's
#     - change B cell's neighbor to A2
#     - increase F's and I's columnspan by 1
#
# 2. Second task isn't so obvious because there is the grid's
#    property of hiding a cell if it is empty. So we should set
#    a minimal size of cells spanned by A widget in order to make
#    its enlarging cell to be seen. By the way the reason is same
#    as for setting -csz of D widget.
#    So, our actions are the following:
#     - enlarge A widget by 1 cell and set its -csz property
#     - increase F's and I's columnspan by 1
#
# Increasing F's and I's columnspan is necessary in both cases because
# a new cell is added above them.
#
# 3. The third layout is like this:
#
# +--------+----------------------------------------------+
# |        |                     B                        |
# |   A    |--------------------+-------------------------|
# |        |         C          |            D            |
# |-----+--+--------------------+-+-----------+-----------|
# |     |                         |           |           |
# |  E  |            F            |     G     |     H     |
# |     |                         |           |           |
# |-----+-------------------------+-----------+-----------|
# |               I               |     J     |     K     |
# +-------------------------------+-----------+-----------+
#
# Note that we think in "columnspan" terms and are not interested with
# the cells' positions. I.e. we have to think about those changes only
# that are necessary.
#
# Press Escape key to go through 1-2-3 steps and to exit.
#
#-------------------------------------------------------------------------

# ______________________ Remove installed (perhaps) packages ____________________ #

puts "Tcl/Tk [package require Tk]"

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

# ________________________ Testing apave _________________________ #

puts "apave [package require apave]"
apave::initWM
apave::APave create pave

## ________________________ Step 1 _________________________ ##

pave makeWindow .win "Test - Original layout "
pave paveWindow .win {
  {butA -   - 2 1 "-st nsew" {-t A}}
  {butB butA L 1 4 "-st nsew" {-t B}}
  {butC butB T 1 1 "-st nsew" {-t C}}
  {butD butC L 1 3 "-st nsew -csz 20" {-t D}}
  {butE butA T 1 1 "-st nsew" {-t E -w 5}}
  {butF butE L 1 2 "-st nsew -rsz 6" {-t F}}
  {butG butF L 1 1 "-st nsew" {-t G}}
  {butH butG L 1 1 "-st nsew" {-t H}}
  {butI butE T 1 3 "-st nsew" {-t I}}
  {butJ butI L 1 1 "-st nsew" {-t J}}
  {butK butJ L 1 1 "-st nsew" {-t K}}
}
pave showModal .win -geometry +2+240

## ________________________ Step 2 _________________________ ##

pave makeWindow .win2 "Test1 - \"A2\" widget added"
pave paveWindow .win2 {
  {butA -   - 2 1 "-st nsew" {-t A}}
  {but2 butA L 2 1 "-st nsew" {-t A2 -w 2}}
  {butB but2 L 1 4 "-st nsew" {-t B}}
  {butC butB T 1 1 "-st nsew" {-t C}}
  {butD butC L 1 3 "-st nsew -csz 20" {-t D}}
  {butE butA T 1 1 "-st nsew" {-t E -w 5}}
  {butF butE L 1 3 "-st nsew -rsz 6" {-t F}}
  {butG butF L 1 1 "-st nsew" {-t G}}
  {butH butG L 1 1 "-st nsew" {-t H}}
  {butI butE T 1 4 "-st nsew" {-t I}}
  {butJ butI L 1 1 "-st nsew" {-t J}}
  {butK butJ L 1 1 "-st nsew" {-t K}}
}
pave showModal .win2 -geometry +360+370

## ________________________ Step 3 _________________________ ##

pave makeWindow .win3 "Test2 - \"A\" widget enlarged"
pave paveWindow .win3 {
  {butA -   - 2 2 "-st nsew -csz 20" {-t A}}
  {butB + L 1 4 "-st nsew" {-t B}}
  {butC + T 1 1 "-st nsew" {-t "Click me to close" -com exit}}
  {butD + L 1 3 "-st nsew -csz 20" {-t D}}
  {buTE butA T 1 1 "-st nsew" {-t E}}
  {buTF + L 1 3 "-st nsew -rsz 6" {-t F -pady 20}}
  {buTG + L 1 1 "-st nsew -cw 1 -rw 1" {-t G}}
  {buTH + L 1 1 "-st nsew" {-t H}}
  {butI buTE T 1 4 "-st nsew" {-t I}}
  {butJ butI L 1 1 "-st nsew" {-t J}}
  {butK butJ L 1 1 "-st nsew" {-t K}}
}
pave showModal .win3 -geometry +750+500

# ________________________ Exit _________________________ #

pave destroy
exit

# ________________________ EOF _________________________ #
