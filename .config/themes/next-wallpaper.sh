#!/bin/bash
# Cycle to next wallpaper for current theme
# Usage: next-wallpaper.sh

THEMES_DIR="$HOME/.config/themes"
CURRENT_DIR="$THEMES_DIR/current"

# Get current theme base name
if [[ ! -f "$CURRENT_DIR/theme.base" ]]; then
    echo "Error: No theme currently applied" >&2
    exit 1
fi

BASENAME=$(cat "$CURRENT_DIR/theme.base")
BACKGROUNDS_DIR="$THEMES_DIR/backgrounds/$BASENAME"

if [[ ! -d "$BACKGROUNDS_DIR" ]]; then
    echo "Error: No backgrounds directory for theme: $BASENAME" >&2
    exit 1
fi

# Get list of wallpapers
mapfile -t WALLPAPERS < <(find "$BACKGROUNDS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "Error: No wallpapers found for theme: $BASENAME" >&2
    exit 1
fi

# Get current wallpaper
CURRENT=""
if [[ -f "$CURRENT_DIR/wallpaper" ]]; then
    CURRENT=$(cat "$CURRENT_DIR/wallpaper")
fi

# Find next wallpaper
NEXT_INDEX=0
for i in "${!WALLPAPERS[@]}"; do
    if [[ "${WALLPAPERS[$i]}" == "$CURRENT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#WALLPAPERS[@]} ))
        break
    fi
done

NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# Save and apply
echo "$NEXT_WALLPAPER" > "$CURRENT_DIR/wallpaper"
osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$NEXT_WALLPAPER\"" 2>/dev/null

echo "Wallpaper: $(basename "$NEXT_WALLPAPER")"
