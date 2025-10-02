#!/bin/bash

# It is simple script for Thunar "Custom actions". It gets filename from right button click
# and source its gamma by wal then set wallpaper by feh.

file="$@"

wal -i "$file" -n
feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
