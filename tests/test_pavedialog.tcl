#! /usr/bin/env tclsh

###########################################################################
#
# Tests for PaveDialog and PaveInput (dialogs of pave, wrapper of grid).
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

namespace eval t {

  variable textTags [list [list "dark" "-foreground black"] \
                          [list "b" "-font {-weight bold -size 14}"] \
                          [list "i" "-font {-slant italic -size 14}"] \
                          [list "red" "-foreground red"]]

  proc test1 {args} {
    return [dlg ok info "Dialog OK$::csN" \
      "Hey that Pushkin!\nHey that son of bitch!" -g +400+200 -scroll 0 {*}$args]
  }

  proc test2 {args} {
    return [dlg yesno ques "Dialog YESNO$::csN" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Do you agree?" YES -g +425+225 -scroll 0 {*}$args]
  }

  proc test3 {args} {
    variable textTags
    set res [dlg okcancel "" "Dialog OKCANCEL$::csN" \
      " <dark>Hey that <red><b> Pushkin </b></red>!
 Hey that son of bitch!
 ---
 Do you agree? <i>Cancel</i> if not.</dark>


The text is restricted with 6 rows at start.
...
So, it has some hidden parts viewed through the scrolling or the resizing.
...
...
...
 " TEXT -g +450+250 -text 1 -tags textTags -width 30 -height 6 -bg white \
 -head "When presented at first\nit's a \"changeable text message\"." \
 -hsz "12 -slant italic -weight normal" {*}$args]
    set textTags [lreplace $textTags 0 0 [list "dark" "-foreground yellow"]]
    return $res
  }

  proc test4 {args} {
    return [dlg yesnocancel ques "Dialog YESNOCANCEL$::csN" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Do you agree?
Or hate the question?
(Choose Cancel in such case)" YES -g +475+275 -scroll 0 {*}$args -timeout {10 ButNO}]
  }

  proc ::t::browser {url} {
    # open is the OS X equivalent to xdg-open on Linux, start is used on Windows
    set commands {xdg-open open start}
    foreach browser $commands {
      if {$browser eq "start"} {
        set command [list {*}[auto_execok start] {}]
      } else {
        set command [auto_execok $browser]
      }
      if {[string length $command]} {
        break
      }
    }
    if {[string length $command] == 0} {
      puts "ERROR: couldn't find browser"
    }
    if {[catch {exec {*}$command $url &} error]} {
      puts "ERROR: couldn't execute '$command':\n$error"
    }
  }

  proc test5 {args} {
    return [dlg retrycancel err "Dialog RETRYCANCEL$::csN" \
      "<link>::t::browser https://en.wikipedia.org/w/index.php?cirrusUserTesting=classic-explorer-i&search=Pushkin@@wikipedia about Pushkin@@</link>Hey that Pushkin!\nHey that son of bitch!
---
Retry the reading of Pushkin? Cancel if not." RETRY -g +500+300 {*}$args -timeout {37 Lab1}]
  }

  proc test6 {args} {
    return [dlg abortretrycancel err "Dialog ABORTRETRYCANCEL$::csN" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Abort or retry the reading of Pushkin? Cancel if not sure." RETRY -g +525+325 {*}$args]
  }

  proc test7 {args} {
    return [dlg misc info "Dialog MSC$::csN" "\nAsk for HELLO\n" \
      {Home 1 {Run me, drink not} run Undo 3 Redo 4 Help 5 Cancel 0 } \
      run -g +350+350 {*}$args]
  }

  proc test8 {args} {
    # initialize variables
    if {![info exist ::t8ent1]} {
      lassign "" ::t8ent1 ::t8fil1 ::t8fis1 ::t8dir1 ::t8fon1 ::t8clr1 ::t8dat1 ::t8chb1 ::t8rad1 ::t8spx1
      set ::t8lbx1 [set ::t8cbx1 Second]
      set ::t8fco1 test2_fco.dat
      set ::t8opc1 "multi word example"
      set ::t8tex1 {It's a sample of
multiline entry field aka
- text\n- memo\n- note}
    }
    # various methods are used while setting the values of widgets' vars:
    #   [list $varname] and "{$varname}" for strings
    #   $varname for integers and booleans
    #   $::t8tex1 for text
    set rellist {- Father Mother Son Daughter Brother Sister Uncle Aunt Cousin {Big Brother} "Second cousin" "1000th cousin"}
    set res [dlg2 input - "Dialog INPUT$::csN" [list \
      seh1 {{} {-pady 9}} {} \
      ent1 {{Enter general info........}} [list $::t8ent1] \
      fil1 {{Choose a file to read.....} {} {-title {Choose a file to read}}} [list $::t8fil1] \
      fis1 {{Choose a file to save.....} {} {-title {Choose a file to save}}} "{$::t8fis1}" \
      dir1 {{Choose a directory........} {} {-title {Choose a directory}}} "{$::t8dir1}" \
      fon1 {{Choose a font.............} {} {-title {Choose a font}}} "{$::t8fon1}" \
      clr1 {{Choose a color............} {} {-title {Choose a color}}} "{$::t8clr1}" \
      dat1 {{Choose a date.............} {} {-title {Choose a date}}} "{$::t8dat1}" \
      seh2 {{} {-pady 9}} {} \
      chb1 {{Check the demo checkbox...}} $::t8chb1 \
      rad1 {{Check the radio button....}} [list "$::t8rad1" Giant Big Small "None of these"] \
      seh3 {{} {-pady 9}} {} \
      spx1 {{Spinbox from 0 to 99......} {} {-w 4 -justify center -from 0 -to 99}} $::t8spx1 \
      lbx1 [list {Listbox of relations......} {} [list -h 4 -lbxsel $::t8lbx1]] $rellist \
      cbx1 [list {Combobox of relations.....} {-fill none -anchor w} [list -w 20 -h 7 -cbxsel $::t8cbx1]] $rellist \
      opc1 {{Option cascade............} {-fill none -anchor w}} [list $::t8opc1 \
        {{color red green blue -- {{other colors} yellow magenta cyan \
        | #52CB2F #FFA500 #CB2F6A | #FFC0CB #90EE90 #8B6914}} \
        {hue dark medium light} -- {{multi word example}} ok} {-w 20}] \
      fco1 [list {Combobox of file content..} {} [list -h 7 -cbxsel $::t8fco1]] {@@-div1 " \[" -div2 "\] " -ret 1 test2_fco.dat@@ \
        INFO: @@-pos 22 -list {{test2_fco.dat} {other item} trunk DOC} test2_fco.dat@@} \
      seh4 {{} {-pady 9}} {} \
      tex1 {{Text field................} {} {-h 4 -w 55 -tabnext butOK}} $::t8tex1 \
    ] -size 14 -weight bold -buttons {butChange {Edit it} 3 butUndo {Undo it} 4 butRedo {Redo it} 5} -head "Entries, choosers, switchers, boxes..." {*}$args]
    if {[lindex $res 0]} {
      lassign [dlg2 valueInput] ::t8ent1 ::t8fil1 ::t8fis1 ::t8dir1 ::t8fon1 ::t8clr1 ::t8dat1 ::t8chb1 ::t8rad1 ::t8spx1 ::t8lbx1 ::t8cbx1 ::t8opc1 ::t8fco1 ::t8tex1
    }
    return $res
  }

  proc test9 {args} {
    # example from pave docs:
    if {![info exist ::login]} {
      set ::login "aplsimple"
      set ::password "12q`\"\{7qweeklmd"
    }
    set res [dlg input ques "My site$::csN" [list \
      entLogin {{Login......}} [list $::login] \
      entPassw {{Password...} {} {-show *}} [list $::password] \
    ] -weight bold -head "\n Enter to register here:" {*}$args]
    if {[lindex $res 0]} {
      lassign [dlg valueInput] ::login ::password
    }
    return $res
  }


  # ________________________ EONS _________________________ #

}

###########################################################################
# Run the tests

apave::initWM

## ________________________ Test record/playback _________________________ ##

if 0 {
  set playtkl_dir ~/PG/github/playtkl_TESTS/
  if {[file exists $playtkl_dir]} {
    set playtkl_log $playtkl_dir/test_pavedialog-2.alm
    source [file join [file join $::testdirname .. .. playtkl] playtkl.tcl]
#!    playtkl::inform YES
    if 0 {
      # 1. recording
      after 50 "playtkl::record $playtkl_log F12"
    } else {
      # 2. playing
      after 50 "playtkl::play $playtkl_log F12"
    }
  }
}

# firstly show dialogs without checkboxes
apave::APave create dlg
apave::APave create dlg2
catch {::transpops::run [file join $::testdirname ../.bak/transpops_dialog.txt] {<Control-t> <Alt-t>} .dia}
set ::csN ""
set dn "Don't show this again"
puts "ok  = [t::test1 -weight bold -size 8 -text 1]"
puts "yn  = [t::test2 -weight bold -size 10 -text 1 -ch $dn]"
puts "oc  = [t::test3 -weight bold -size 12 -bg #ffffc4 -ro 0]"
puts "ync = [t::test4 -weight bold -size 14 -text 1 -width 30 -height 6 -fg green]"
puts "rc  = [t::test5 -weight bold -size 16]"
puts "arc = [t::test6 -weight bold -size 18]"
puts "msc = [t::test7 -size 20]"
puts "inp = [t::test8 -g +575+175 -focus en*dir*]"
puts "pavedoc = [t::test9 -g +575+375]"

# show dialogs with checkboxes, in cycle
lassign {0 0 0 0 0 0 0 0} r1 r2 r3 r4 r5 r6 r7 r8 r9
set clrsc 0
set clrscdark [list 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41]
while 1 {
  set cs [lindex $clrscdark $clrsc]
  set ::csN " / CS:$cs"
  dlg csSet $cs
  if {[incr clrsc] == [llength $clrscdark]} {set clrsc 0}
  puts --------------------------------
  set curr [set totr 0]
  foreach {n type} {1 OK 2 YN 3 OC 4 YNC 5 RC 6 ARC 7 MSC 8 INP 9 PAVEDOC} {
    if {[set r$n]<10} {
      set res [t::test$n -ch "$dn" -centerme yes]
      puts "$type = $res"
      set r$n [lindex $res 0]
      if {![string is integer [set r$n]]} {
        set r$n [expr {[string last 10 [set r$n]]>0} ? 10 : 0]
      }
    }
    incr curr [expr [set r$n] / 10]
    incr totr
  }
  ;# cycle till none be shown
  if {$curr == $totr} break
  # ask for continuation anyway
  if {[lindex [dlg yesno warn "UFF..." "\n Break the dance? \n" NO \
      -weight bold -size 22 -c "ghost white"] 0] == 1} {
    break
  }
}

apave::APave destroy
if {[info commands playtkl::end] ne {}} playtkl::end
exit
