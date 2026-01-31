#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

if [[ "$SENDER" == "volume_change" ]]; then
    VOLUME="$INFO"
else
    VOLUME=$(osascript -e 'output volume of (get volume settings)')
fi

MUTED=$(osascript -e 'output muted of (get volume settings)')

# Icons matching Omarchy's pulseaudio format-icons
if [[ "$MUTED" == "true" || "$VOLUME" -eq 0 ]]; then
    ICON=""
    COLOR=$FOREGROUND_DIM
elif [[ "$VOLUME" -ge 66 ]]; then
    ICON=""
    COLOR=$FOREGROUND
elif [[ "$VOLUME" -ge 33 ]]; then
    ICON=""
    COLOR=$FOREGROUND
else
    ICON=""
    COLOR=$FOREGROUND
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR"
