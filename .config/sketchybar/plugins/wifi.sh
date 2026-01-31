#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get wifi info
WIFI_INFO=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null)

if [[ -z "$WIFI_INFO" || "$WIFI_INFO" == *"AirPort: Off"* ]]; then
    ICON="󰤮"
    COLOR=$FOREGROUND_DIM
else
    SSID=$(echo "$WIFI_INFO" | awk -F': ' '/ SSID/{print $2}')
    RSSI=$(echo "$WIFI_INFO" | awk -F': ' '/agrCtlRSSI/{print $2}')
    
    if [[ -z "$SSID" ]]; then
        ICON="󰤮"
        COLOR=$FOREGROUND_DIM
    else
        # Signal strength icons (matching Omarchy's network format-icons)
        if [[ "$RSSI" -ge -50 ]]; then
            ICON="󰤨"
        elif [[ "$RSSI" -ge -60 ]]; then
            ICON="󰤥"
        elif [[ "$RSSI" -ge -70 ]]; then
            ICON="󰤢"
        elif [[ "$RSSI" -ge -80 ]]; then
            ICON="󰤟"
        else
            ICON="󰤯"
        fi
        COLOR=$FOREGROUND
    fi
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR"
