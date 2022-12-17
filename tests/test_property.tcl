#! /usr/bin/env tclsh
###########################################################################
#
# This script contains testing samples for the ObjectProperty class that
# allows to mix-in into a class/object the getter and setter of properties.
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


oo::class create SomeClass {
  mixin apave::ObjectProperty
  variable _OP_Properties
  method summary {} {
    puts "Instances: [set obj [info class instances SomeClass]]"
    puts "Namespace: [info object namespace $obj]"
    puts "Namespace: [namespace current]"
    puts "Variables: [info vars]"
    set iter [array startsearch _OP_Properties]
    while {[array anymore _OP_Properties $iter]} {
      set el [array nextelement _OP_Properties $iter]
      puts "Value of $el"
      puts "      is $_OP_Properties($el)"
    }
  }
}

SomeClass create someobj

set prop1 "Property1"
set prop2 "Property2"

# get default property
puts $prop1=[someobj getProperty $prop1 ???]

# set ang get property
someobj setProperty $prop1 100
puts $prop1=[someobj getProperty $prop1 ???]

# get default 2nd property
puts $prop2=[someobj getProperty $prop2 !!!]

# set ang get 2nd property
someobj setProperty $prop2 200
puts $prop2=[someobj getProperty $prop2 !!!]

# get a property by 'set prop'
puts $prop2=[someobj setProperty $prop2]
# set a property by 'set prop val'
puts $prop2=[someobj setProperty $prop2 300]

# set another property
someobj setProperty someprop "someval"

# put out a summary
puts "-----------------------------"
someobj summary
puts "-----------------------------"

puts "\nBelow should be an error: 'obj setProperty' need 1 or 2 args:\n"
puts $prop2=[someobj setProperty $prop1 2 3]

# unreachable code
SomeClass destroy
