#!/bin/sh

# Set the framerate for custom monitor.
# Created by ARandr GUI commonly. 

xrandr --output DP-1 --off --output HDMI-1 --primary --rate 75 --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
