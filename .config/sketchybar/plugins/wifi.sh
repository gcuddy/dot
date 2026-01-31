#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Check WiFi using system_profiler (more reliable than networksetup)
WIFI_SSID=$(system_profiler SPAirPortDataType 2>/dev/null | grep -A1 "Current Network Information:" | grep -v "Current Network" | head -1 | sed 's/^[[:space:]]*//' | sed 's/:$//')

# Check if we have network connectivity
HAS_NETWORK=$(route get default 2>/dev/null | grep -c "interface")

if [[ -n "$WIFI_SSID" ]]; then
    # Connected via WiFi
    ICON="󰤨"
    COLOR=$FOREGROUND
elif [[ "$HAS_NETWORK" -gt 0 ]]; then
    # Connected but not wifi (ethernet/thunderbolt)
    ICON="󰀂"
    COLOR=$FOREGROUND
else
    # No connection
    ICON="󰤮"
    COLOR=$FOREGROUND_DIM
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR"
