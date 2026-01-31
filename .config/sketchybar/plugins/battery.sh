#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [[ -z "$PERCENTAGE" ]]; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

# Icons matching Omarchy's battery format-icons
if [[ -n "$CHARGING" ]]; then
    case "$PERCENTAGE" in
        100)       ICON="󰂅" ;;
        9[0-9])    ICON="󰂋" ;;
        8[0-9])    ICON="󰂊" ;;
        7[0-9])    ICON="󰢞" ;;
        6[0-9])    ICON="󰂉" ;;
        5[0-9])    ICON="󰢝" ;;
        4[0-9])    ICON="󰂈" ;;
        3[0-9])    ICON="󰂇" ;;
        2[0-9])    ICON="󰂆" ;;
        *)         ICON="󰢜" ;;
    esac
    COLOR=$GREEN
else
    case "$PERCENTAGE" in
        100)       ICON="󰁹" ;;
        9[0-9])    ICON="󰂂" ;;
        8[0-9])    ICON="󰂁" ;;
        7[0-9])    ICON="󰂀" ;;
        6[0-9])    ICON="󰁿" ;;
        5[0-9])    ICON="󰁾" ;;
        4[0-9])    ICON="󰁽" ;;
        3[0-9])    ICON="󰁼" ;;
        2[0-9])    ICON="󰁻" ; COLOR=$YELLOW ;;
        1[0-9])    ICON="󰁺" ; COLOR=$RED ;;
        *)         ICON="󰁺" ; COLOR=$RED ;;
    esac
    COLOR=${COLOR:-$FOREGROUND}
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR" \
    drawing=on
