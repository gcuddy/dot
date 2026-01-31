#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# CPU percentage
CPU=$(top -l 2 -n 0 | tail -1 | awk '{print int($3 + $7)}')

if [[ "$CPU" -ge 80 ]]; then
    COLOR=$RED
elif [[ "$CPU" -ge 50 ]]; then
    COLOR=$YELLOW
else
    COLOR=$FOREGROUND_DIM
fi

sketchybar --set "$NAME" icon.color="$COLOR"
