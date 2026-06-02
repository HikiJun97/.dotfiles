#!/bin/bash

# $1 = workspace ID, $NAME = sketchybar item name
WORKSPACE=$1

# Count windows in this workspace
WINS=$(aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | wc -l | tr -d ' ')

if [ "$WORKSPACE" = "$FOCUSED_WORKSPACE" ]; then
    # Active workspace
    sketchybar --set "$NAME" \
        icon.color=0xffffffff \
        background.drawing=on \
        background.color=0x55ffffff
elif [ "$WINS" -gt 0 ]; then
    # Has windows but not focused
    sketchybar --set "$NAME" \
        icon.color=0xbbffffff \
        background.drawing=off
else
    # Empty workspace
    sketchybar --set "$NAME" \
        icon.color=0x20ffffff \
        background.drawing=off
fi
