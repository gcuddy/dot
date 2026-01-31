#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Use media-control (works with Apple Music, Spotify, browser media, etc.)
# https://github.com/ungive/media-control

ARTWORK_DIR="/tmp/sketchybar_media"
ARTWORK_PATH="$ARTWORK_DIR/artwork.jpg"

if ! command -v media-control &>/dev/null; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# Get media info
DATA=$(media-control get 2>/dev/null)

PLAYING=$(echo "$DATA" | jq -r '.playing')
TITLE=$(echo "$DATA" | jq -r '.title // empty')
ARTIST=$(echo "$DATA" | jq -r '.artist // empty')
ARTWORK=$(echo "$DATA" | jq -r '.artworkData // empty')

if [[ "$PLAYING" == "true" && -n "$TITLE" ]]; then
    if [[ -n "$ARTIST" ]]; then
        LABEL="$TITLE - $ARTIST"
    else
        LABEL="$TITLE"
    fi
    
    # Truncate if too long
    if [[ ${#LABEL} -gt 35 ]]; then
        LABEL="${LABEL:0:32}..."
    fi
    
    # Save artwork if available
    if [[ -n "$ARTWORK" && "$ARTWORK" != "null" ]]; then
        mkdir -p "$ARTWORK_DIR"
        echo "$ARTWORK" | base64 -d > "$ARTWORK_PATH" 2>/dev/null
        
        # Calculate scale to fit ~20px height (bar is 28px)
        HEIGHT=$(sips -g pixelHeight "$ARTWORK_PATH" 2>/dev/null | awk '/pixelHeight/{print $2}')
        if [[ -n "$HEIGHT" && "$HEIGHT" -gt 0 ]]; then
            SCALE=$(echo "scale=3; 20 / $HEIGHT" | bc)
        else
            SCALE="0.035"
        fi
        
        sketchybar --set "$NAME" \
            icon.background.image="$ARTWORK_PATH" \
            icon.background.image.scale="$SCALE" \
            icon.background.image.corner_radius=3 \
            icon.background.drawing=on \
            icon="" \
            icon.padding_right=24 \
            label="$LABEL" \
            drawing=on
    else
        sketchybar --set "$NAME" \
            icon.background.drawing=off \
            icon="󰎈" \
            icon.color=$ACCENT_COLOR \
            icon.padding_right=4 \
            label="$LABEL" \
            drawing=on
    fi
else
    sketchybar --set "$NAME" drawing=off
fi
