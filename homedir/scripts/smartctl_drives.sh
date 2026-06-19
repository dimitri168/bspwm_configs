#!/bin/bash

for i in a b c d; do
	echo ''
	sudo smartctl -a /dev/sd$i | grep -i "Device Model" | tr -s ' '
	sudo smartctl -a /dev/sd$i | grep -i "Power_On_Hours" | awk '{print $2, $10}'
done

echo ''
