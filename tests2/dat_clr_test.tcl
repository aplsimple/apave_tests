#! /usr/bin/env tclsh
##########################################################################################
#
# Tests date/color choosers & modal/non-modal windows.
# Works for apave 4.2.0+ only.
#
# Details about the test:
# - all windows except for "." are made with pave makeWindow/paveWindow
# - date and calendar choosers as "dat", "clr" entry fields of apave
# - both "dat" and "clr" choosers are open *under* their fields
# - both "dat" and "clr" choosers are open with F2 key in their entries
# - built-in calendar: "daT" field of apave, its option "-width 3" being remarkable
# - -com option for 2 calendars, just to response at clicking days
# - -popup option for 2 calendars to show normally a context menu at %X, %Y coordinates
# - choosers of buttons are open next to the mouse pointer, with "-geometry pointer+10+10"
# - "-onclose destroy" to destroy windows instead of "destroy $w", both examples below
# - "-centerme . -geometry 300x300" sets a window's sizes and centers it over "."
# - -moveall option of 2 color choosers is saved/restored at calls,
#      both are only for Unix (tkcc package be used)
# - -validate & -validatecommand options are for updating moveall
# - paved windows are shown with showModal default "-escape 1", to close them with Esc key
# - "-resizable no" makes the main window unresizable, others being not
# - Spanish locale forced for both choosers (works with Tcl/Tk deployed, not with tclkits)
#
# The "clr" field is named as Clr1 just to update the field when the color is choosen
# from the button (both choosers use the same variable).
#
# The returned dates are formatted (e.g. 08-09-2023), while the %d,%m,%y of -com options
# contain normal digitals (e.g. 8,9,2023) => no issues with incorrect octals 08 & 09
# like [expr 08+1].
#
##########################################################################################

# ________________________ packages / vars _________________________ #

set auto_path [linsert $auto_path 0 /home/apl/PG/github/apave]
package require apave
puts "apave version : [package require apave]"

# force Espanol
msgcat::mclocale es

set datefmt %Y-%m-%d
set selectedDate [set selectedDate2 [clock format [clock seconds] -format $datefmt]]

set moveall 1
set butfg [set butbg {}]
set selectedColor #000

# ________________________ procs _________________________ #

proc launchCal {parent} {
  pave sourceKlnd
  set res [klnd::calendar -title "Pick a date" \
    -geometry pointer+10+10 \
    -parent $parent \
    -dateformat $::datefmt \
    -tvar ::selectedDate -weekday %w \
    -popup {puts "D.M.Y: %d.%m.%y on right click, pos: %X,%Y"} \
    -com {puts "D.M.Y: %d.%m.%y"}]
  if {$res ne {}} {
    puts "Selected date: $::selectedDate"
  }
}
#_______________________

proc ClrOptions {} {
  lassign [::tk::dialog::color::GetOptions] ::moveall ::butfg ::butbg
  if {$::butbg ne {}} {
    [pave BuTCol] config -fg $::butfg -bg $::butbg
  }
  return 1
}
#_______________________

proc launchColor {parent} {
  set res [pave chooser colorChooser ::selectedColor -parent $parent \
    -moveall $::moveall -geometry pointer+10+10]
  if {$res ne {}} {
    ClrOptions
    puts "Selected color: $::selectedColor, moveall: $::moveall"
    pave validateColorChoice Clr1
  }
}
#_______________________

proc launchTop {parent} {
  set t .t3
  set ::iter "(.t3 #[incr ::$t])" ;# so you know which incarnation we're talking about
  pave3 makeWindow $t "silly $t ($::iter)"
  pave3 paveWindow $t {
    {lab - - - - {} {-t "yet another silly\nmodal toplevel $::iter.\n\
    please close me."}}
  }
  puts "launching silly toplevel $::iter"
  pave showModal $t -centerme .t -onclose destroy
  puts "silly modal toplevel $::iter ended."
}

# ________________________ main pg _________________________ #

if {[::isunix]} {ttk::style theme use alt}
wm geometry . 200x200+500+300; update
pack [ttk::button .b0 -text "clicky 0" -command {puts "clicky 0!"}]
apave::APave create pave
apave::APave create pave2
apave::APave create pave3
pave2 makeWindow .t2 t2
pave2 paveWindow .t2 {{but - - - - {} {-t "clicky 1" -com {puts "clicky 1!"}}}}
pave showModal .t2 -centerme . -geometry 300x300 -modal 0 -waitvar 0 -onclose destroy
pave makeWindow .t "date / color choosers"
pave paveWindow .t {
  {buTCal - - 1 1 {} {-t "calendar..." -w 10 -com {::launchCal .t}}}
  {BuTCol + T 1 1 {} {-t "color..." -w 10 -com {::launchColor .t}}}
  {buTTop + T 1 1 {} {-t "toplevel..." -w 10 -com {::launchTop .t}}}
  {dat buTCal L 1 1 {-st w} {-justify center -w 11 -tvar ::selectedDate -dateformat $::datefmt}}
  {Clr1 + T 1 1 {-st w} {-justify center -w 11 -tvar ::selectedColor -validate all -validatecommand ::ClrOptions}}
  {seh buTTop T 1 2}
  {daT + T 1 2 {} {-tvar ::selectedDate2 -dateformat $::datefmt -width 3 -com {puts  "Selected date #2: \$::selectedDate2 (D.M.Y: %d.%m.%y)"} -popup {puts "D.M.Y: %d.%m.%y on right click, pos: %X,%Y"}}}
}
pave showModal .t -centerme .t2 -resizable no
destroy .t
puts "modal ended."
