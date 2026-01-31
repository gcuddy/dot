#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

if [[ "$SELECTED" == "true" ]]; then
    sketchybar --set "$NAME" \
        icon.color=$FOREGROUND \
        background.drawing=on \
        background.color=$ACCENT_COLOR
else
    sketchybar --set "$NAME" \
        icon.color=$FOREGROUND_DIM \
        background.drawing=off
fi
