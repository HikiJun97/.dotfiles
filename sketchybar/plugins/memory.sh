#!/bin/bash

MEM=$(memory_pressure | grep "System-wide memory free percentage" | awk '{print 100-$NF}' | tr -d '%')
MEM_USED=$(vm_stat | awk '
/Pages active/     { active=$3 }
/Pages wired/      { wired=$4 }
END {
    used=(active+wired)*4096/1073741824
    printf "%.1f", used
}')

sketchybar --set "$NAME" label="${MEM_USED}GB"
