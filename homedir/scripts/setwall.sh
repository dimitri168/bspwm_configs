#!/bin/bash

# Sets the unique wallpaper for certain desktop.
# Create $HOME/.local/share/walls and put inside pictures named by numbers starting zero.
# No file extension allowed.

DISK_WALL_DIR="$HOME/.local/share/walls"
WALL_CMD="feh --bg-fill"
WALL_DIR="/tmp/wallpapers"
 
mkdir "$WALL_DIR"
cp --no-dereference "$DISK_WALL_DIR"/{0,1,2,3,4,5} "$WALL_DIR"
 
xprop -root -spy _NET_CURRENT_DESKTOP | (
  while read -r; do
 
# Poor man's conky
#    if [[ $CURR_DESKTOP -eq 9 ]]; then
#      habak -mS -hi "$WALL_DIR/$CURR_DESKTOP" -mf "/usr/share/fonts/adobe-source-code-pro/SourceCodePro-BoldIt.otf" -mh 12 -mp 30,100 -mc 12,32,52,255 -ht "$(~/.local/bin/scripts/favourite_habak)"
#      continue
#    fi
 
    $WALL_CMD "$WALL_DIR/${REPLY##* }" &
    done
)