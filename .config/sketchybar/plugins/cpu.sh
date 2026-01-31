#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get CPU usage (faster method using ps)
CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu)
CPU_TOTAL=$(echo "$CPU_INFO" | awk "{sum+=\$1} END {printf \"%.0f\", sum/$CORE_COUNT}")

# Color based on usage
if [[ "$CPU_TOTAL" -ge 80 ]]; then
    COLOR=$RED
elif [[ "$CPU_TOTAL" -ge 50 ]]; then
    COLOR=$YELLOW
else
    COLOR=$FOREGROUND_DIM
fi

sketchybar --set "$NAME" \
    icon.color="$COLOR" \
    label="${CPU_TOTAL}%" \
    label.drawing=on
