#!/bin/sh


COND=NULL;

COND=$(curl -s https://wttr.in/43.320235,76.925791\?format="%t\n")

if [ -z "$COND" ]
	then echo "Waiting..."
	else
	echo "$COND"
fi