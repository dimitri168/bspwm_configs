#!/bin/bash

awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc_rus |
    column -t -s $'\t' |
    rofi -dmenu -i -markup-rows -no-show-icons -width 1000 -lines 15 -yoffset 40 -font "Hack Bold 12" -window-title "System keybindings"
