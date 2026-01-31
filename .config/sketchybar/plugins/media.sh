#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get media info using osascript
STATE=$(osascript -e 'tell application "System Events"
    set _apps to {"Spotify", "Music", "Podcasts", "Arc"}
    repeat with _app in _apps
        if application process _app exists then
            try
                tell application _app
                    if player state is playing then
                        return "playing"
                    end if
                end tell
            end try
        end if
    end repeat
    return "stopped"
end tell' 2>/dev/null)

if [[ "$STATE" == "playing" ]]; then
    # Try to get track info
    INFO=$(osascript -e 'tell application "System Events"
        set _apps to {"Spotify", "Music"}
        repeat with _app in _apps
            if application process _app exists then
                try
                    tell application _app
                        if player state is playing then
                            set _track to name of current track
                            set _artist to artist of current track
                            return _track & " - " & _artist
                        end if
                    end tell
                end try
            end if
        end repeat
        return ""
    end tell' 2>/dev/null)
    
    # Truncate if too long
    if [[ ${#INFO} -gt 40 ]]; then
        INFO="${INFO:0:37}..."
    fi
    
    sketchybar --set "$NAME" \
        icon="󰎈" \
        icon.color=$ACCENT_COLOR \
        label="$INFO" \
        label.drawing=on \
        drawing=on
else
    sketchybar --set "$NAME" drawing=off
fi
