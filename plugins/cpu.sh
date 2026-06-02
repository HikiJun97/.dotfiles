#!/bin/bash

CPU=$(top -l 2 -n 0 | grep "CPU usage" | tail -1 | awk '{print $3}' | tr -d '%')
CPU_INT=${CPU%.*}

if [ "$CPU_INT" -ge 80 ]; then
    COLOR=0xffff6b6b  # red
elif [ "$CPU_INT" -ge 50 ]; then
    COLOR=0xfffac95d  # amber
else
    COLOR=0x99ffffff
fi

sketchybar --set "$NAME" \
    icon="" \
    label="CPU ${CPU_INT}%" \
    label.color=$COLOR
