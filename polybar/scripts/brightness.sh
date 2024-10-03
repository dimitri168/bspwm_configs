#!/bin/sh

MAX='1.0';

case "$1" in
	up)
	xrandr --output HDMI-1 --brightness 1.0;;

	down)
	xrandr --output HDMI-1 --brightness 0.8;;

	current)
	CUR=$(xrandr --verbose | grep -i brightness | sed 's/.*://' | sed -e 's/^[[:space:]]*//');

if [ "$CUR" = "$MAX" ]
	then
	LABEL="%{F#F0C674}"
	else
	LABEL=""
fi
esac

echo "$LABEL";