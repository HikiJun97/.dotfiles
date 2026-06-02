#!/bin/bash

VOL=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

if [ "$MUTED" = "true" ]; then
    ICON="󰝟"
    LABEL="mute"
elif [ "$VOL" -ge 70 ]; then
    ICON="󰕾"
    LABEL="${VOL}%"
elif [ "$VOL" -ge 30 ]; then
    ICON="󰖀"
    LABEL="${VOL}%"
else
    ICON="󰕿"
    LABEL="${VOL}%"
fi

sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
