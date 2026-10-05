#!/bin/bash

for i in {a,b,c,d}; do
	echo ''
	sudo smartctl -a /dev/sd$i | grep -i 'Device Model' | tr -s ' '
	sudo smartctl -i /dev/sd$i | grep -i 'User Capacity' | awk '{print $1, $2, $5, $6}'
	sudo smartctl -a /dev/sd$i | grep -i 'Power_On_Hours' | awk '{print $2, $10}'
        sudo smartctl -a /dev/sd$i | grep -i 'Power_Cycle_Count' | awk '{print $2, $10}'
        sudo smartctl -a /dev/sd$i | grep -i 'Temperature_Celsius' | awk '{print $2, $10}'
done

echo ''
