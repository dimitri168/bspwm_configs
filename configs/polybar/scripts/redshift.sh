#!/bin/sh

changeModeToggle() {
    pkill -USR1 redshift
}

checkIfRunning() {
  if [ $(xrandr --verbose | grep Gamma | sed 's/.*:      //') = '1.0:1.0:1.0' ]; then
    return 0
  else
    return 1
  fi
}

case $1 in 
  toggle)
  changeModeToggle
    ;;
  temperature)
    if checkIfRunning ; then
#		CURRENT_TEMP=$(xrandr --verbose | grep Gamma | sed 's/.*:      //')
		echo ""
    	else
      echo "%{F#F0C674}"
    fi
    ;;
esac