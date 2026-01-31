#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Check bluetooth status
BT_STATUS=$(blueutil --power 2>/dev/null || echo "0")
CONNECTED=$(blueutil --connected 2>/dev/null | wc -l | tr -d ' ')

if [[ "$BT_STATUS" == "0" ]]; then
    ICON="󰂲"
    COLOR=$FOREGROUND_DIM
elif [[ "$CONNECTED" -gt 0 ]]; then
    ICON="󰂱"
    COLOR=$ACCENT_COLOR
else
    ICON=""
    COLOR=$FOREGROUND
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR"
