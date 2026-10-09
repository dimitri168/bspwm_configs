#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#. /etc/X11/Xsession

# Set 75Hz screen refresh rate
$HOME/.screenlayout/screen.sh &

# Restore color gamma and wallpaper from previous login
wal -R

exec bspwm
