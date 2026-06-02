#!/bin/bash

BATT=$(pmset -g batt)
PCT=$(echo "$BATT" | grep -Eo '[0-9]+%' | tr -d '%')
CHARGING=$(echo "$BATT" | grep -c "AC Power")

if [ "$CHARGING" -gt 0 ]; then
    ICON="󰂄"
    COLOR=0xff30d158  # green
elif [ "$PCT" -le 10 ]; then
    ICON="󰁺"
    COLOR=0xffff6b6b  # red
elif [ "$PCT" -le 20 ]; then
    ICON="󰁻"
    COLOR=0xfffac95d  # amber
elif [ "$PCT" -le 40 ]; then
    ICON="󰁽"
    COLOR=0x99ffffff
elif [ "$PCT" -le 60 ]; then
    ICON="󰁿"
    COLOR=0x99ffffff
elif [ "$PCT" -le 80 ]; then
    ICON="󰂁"
    COLOR=0x99ffffff
else
    ICON="󰁹"
    COLOR=0x99ffffff
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color=$COLOR \
    label="${PCT}%"
