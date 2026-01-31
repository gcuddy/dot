#!/bin/bash

# Toggle between formats on click
STATE_FILE="/tmp/sketchybar_clock_state"

if [[ "$1" == "toggle" ]]; then
    if [[ -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
    else
        touch "$STATE_FILE"
    fi
fi

if [[ -f "$STATE_FILE" ]]; then
    # Alternate format: day month week year (like Omarchy's format-alt)
    LABEL=$(date '+%d %B W%V %Y')
else
    # Default format: weekday time (like Omarchy's format)
    LABEL=$(date '+%A %H:%M')
fi

sketchybar --set "$NAME" label="$LABEL"
