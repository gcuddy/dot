#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Simply show the current focused workspace
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

if [[ -n "$FOCUSED" ]]; then
    sketchybar --set aerospace_workspace label="$FOCUSED"
fi
