#!/bin/bash
# SketchyBar colors - sourced from theme system

CONFIG_DIR="$HOME/.config/sketchybar"

# Helper to convert #RRGGBB to 0xAARRGGBB
hex_to_argb() { echo "${1/#\#/0xff}"; }
hex_to_argb_alpha() { echo "0x$1${2/#\#/}"; }

# Default fallback colors (Gruvbox Dark)
export BAR_COLOR=0xcc1d2021
export ITEM_BG_COLOR=0x00000000
export ACCENT_COLOR=0xff83a598
export FOREGROUND=0xffebdbb2
export FOREGROUND_DIM=0xff928374
export BACKGROUND=0xff1d2021
export RED=0xffcc241d
export GREEN=0xff98971a
export YELLOW=0xffd79921
export BLUE=0xff458588
export MAGENTA=0xffb16286
export CYAN=0xff689d6a
export WHITE=0xffa89984

# Override with theme if available
if [[ -f "$CONFIG_DIR/theme-colors.sh" ]]; then
    source "$CONFIG_DIR/theme-colors.sh"
fi
