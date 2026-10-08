#!/bin/sh
# Weather by IP

City=NULL;
Temp=NULL;

City=$(curl -s "wttr.in?format=j1" | jq -r '.nearest_area[0].areaName[0].value')
Temp=$(curl -s "wttr.in?format=%t\n")


if [ -z "$City" ]
	then echo "Waiting..."
	else
	echo "$City $Temp"
fi