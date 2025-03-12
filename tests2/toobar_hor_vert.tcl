#! /usr/bin/env tclsh
###########################################################
# Name:    toobar_hor_vert.tcl
# Author:  Alex Plotnikov  (aplsimple@gmail.com)
# Date:    Mar 12, 2025
# Brief:   Example of horizontal & vertical toolbars.
# License: MIT.
###########################################################

source ../../apave/apave.tcl
wm withdraw .

proc Foo {icon} {tk_messageBox -message "Foo $icon"}

# create icons
foreach icon {yes no info config file undo} {
  image create photo img_$icon -data [apave::iconData $icon small]
}

# create window
set win .example
set pobj ::apave::pavedObj1
::apave::APave create $pobj $win
$pobj makeWindow $win.fra "Toolbars hor./vert."

# lay-out window
$pobj paveWindow $win.fra {
  {fraTop - - 1 3 {-st ew}}
  {.seh - - - - {pack -side bottom -fill x}}
  {.too - - - - {pack} {-array {
    img_yes {{::Foo yes} -tip "Yes\nF1@@-under 2"}
    img_no {{::Foo no} -tip "No\nF2@@-under 2"}
    sev 8
    img_info {{::Foo info} -tip "Info\nF3@@-under 2"}
    img_config {{::Foo config} -tip "Config\nF4@@-under 2"}
    img_file {{::Foo file} -tip "File\nF5@@-under 2"}
    h_ 10 {########## h_ : just to test #########} {}
    sev 8 {########## another separator #########} {}
    img_undo {{::Foo undo} -tip "Undo\nF6@@-under 2"}
  }}}
  {fraLeft fraTop T 1 1 {-st ns}}
  {.too - - - - {pack -side left -anchor n} {-orient vert -array {
    v_ 10 {########## v_ : just to test #########} {}
    img_yes {{::Foo yes} -tip "Yes\nF1@@-under 2"}
    img_no {{::Foo no} -tip "No\nF2@@-under 2"}
    seh 8
    img_info {{::Foo info} -tip "Info\nF3@@-under 2"}
    img_config {{::Foo config} -tip "Config\nF4@@-under 2"}
    img_file {{::Foo file} -tip "File\nF5@@-under 2"}
    seh 8 {########## another separator #########} {}
    img_undo {{::Foo undo} -tip "Undo\nF6@@-under 2"}
  }}}
  {.sev - - - - {pack -side left -fill y}}
  {fraCenter fraLeft L 1 1 {-st nswe -cw 1 -rw 1}}
  {.tex - - - - {pack -side left -expand 1 -fill both} {-h 4 -w 4 -wrap none}}
  {.sbv .tex L - - {pack -after %w}}
  {.sbh .tex T - - {pack -before %w}}
}

# show window
set res [$pobj showModal $win -minsize {100 100} -escape 1 -onclose destroy]
catch {destroy $win}
$pobj destroy
exit