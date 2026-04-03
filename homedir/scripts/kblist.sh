#!/bin/bash

awk '/^[a-z]/ && last {print "<small>",$0,"\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc_rus |
  column -t -s $'\t' |
  rofi -dmenu -i -markup-rows -no-show-icons -yoffset 40 -font "Hack Bold 12" \
    -window-title "Сокращения" -theme glue_pro_blue \
    -theme-str 'listview {lines: 34;}' -theme-str 'window {width: 47%;}'
