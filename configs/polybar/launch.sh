#!/bin/bash

# Завершить текущие экземпляры polybar
killall -q polybar

# Ожидание полного завершения работы процессов
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Запуск Polybar со стандартным расположением конфигурационного файла в ~/.config/polybar/
polybar top_left &
polybar top_middle1 &
polybar top_middle2 &
polybar top_right &



echo "Polybar загрузился..."
