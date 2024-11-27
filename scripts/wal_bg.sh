#!/bin/env bash

# Script gets filename with path from nitrogen config
# and sets system gamma by wal.

f_path=$(cat ~/.config/nitrogen/bg-saved.cfg | grep file | sed 's/.*=//')
#f_name=$(cat ~/.config/nitrogen/bg-saved.cfg | grep file | cut -d '/' -f6)

#echo $f_path
#echo $f_name

wal -i $f_path
#bspc wm -r
