#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Check network status
# First check wifi
WIFI_DEV=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $2}')
WIFI_SSID=""
if [[ -n "$WIFI_DEV" ]]; then
    WIFI_SSID=$(networksetup -getairportnetwork "$WIFI_DEV" 2>/dev/null | sed 's/Current Wi-Fi Network: //')
    [[ "$WIFI_SSID" == *"not associated"* ]] && WIFI_SSID=""
fi

# Check if we have any network connection
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
