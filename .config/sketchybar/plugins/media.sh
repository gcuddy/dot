#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Use media-control (works with Apple Music, Spotify, browser media, etc.)
# https://github.com/ungive/media-control

if ! command -v media-control &>/dev/null; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# Get media info (exclude artwork to keep it fast)
DATA=$(media-control get 2>/dev/null | jq -r '{playing, title, artist}')

PLAYING=$(echo "$DATA" | jq -r '.playing')
TITLE=$(echo "$DATA" | jq -r '.title // empty')
ARTIST=$(echo "$DATA" | jq -r '.artist // empty')

if [[ "$PLAYING" == "true" && -n "$TITLE" ]]; then
    if [[ -n "$ARTIST" ]]; then
        LABEL="$TITLE - $ARTIST"
    else
        LABEL="$TITLE"
    fi
    
    # Truncate if too long
    if [[ ${#LABEL} -gt 40 ]]; then
        LABEL="${LABEL:0:37}..."
    fi
    
    sketchybar --set "$NAME" \
        icon="󰎈" \
        icon.color=$ACCENT_COLOR \
        label="$LABEL" \
        drawing=on
else
    sketchybar --set "$NAME" drawing=off
fi
