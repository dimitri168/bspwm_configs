#!/bin/sh

MAX='1.0';

#primary=${xrdb:color1:#222}

case "$1" in
	up)
	xrandr --output HDMI-1 --brightness 1.0;;

	down)
	xrandr --output HDMI-1 --brightness 0.8;;

	current)
	CUR=$(xrandr --verbose | grep -i brightness | sed 's/.*://' | sed -e 's/^[[:space:]]*//');

if [ "$CUR" = "$MAX" ]
	then
	LABEL=""
	else
	LABEL=""
fi
esac

echo "$LABEL";
