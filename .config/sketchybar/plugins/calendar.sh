#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

# Get next event using icalBuddy
# -n = include only events from now on
# -ea = exclude all-day events
# -li 1 = limit to 1 event
# -nc = no calendar names
# -npn = no property names
# -ps "| - |" = property separator

NEXT_EVENT=$(icalBuddy -n -ea -li 1 -nc -npn -iep "title,datetime" -ps "| - |" -tf "%H:%M" eventsToday 2>/dev/null)

if [[ -z "$NEXT_EVENT" ]]; then
    # No events today, check tomorrow
    NEXT_EVENT=$(icalBuddy -ea -li 1 -nc -npn -iep "title,datetime" -ps "| - |" -tf "%H:%M" eventsToday+1 2>/dev/null)
    if [[ -n "$NEXT_EVENT" ]]; then
        NEXT_EVENT="Tomorrow: $NEXT_EVENT"
    fi
fi

if [[ -n "$NEXT_EVENT" ]]; then
    # Extract time and title
    TIME=$(echo "$NEXT_EVENT" | sed 's/ - .*//' | head -1)
    TITLE=$(echo "$NEXT_EVENT" | sed 's/^[^-]*- //' | head -1)
    
    # Truncate title if too long
    if [[ ${#TITLE} -gt 25 ]]; then
        TITLE="${TITLE:0:22}..."
    fi
    
    LABEL="$TIME $TITLE"
    ICON=""
    COLOR=$FOREGROUND
else
    LABEL=""
    ICON=""
    COLOR=$FOREGROUND_DIM
fi

sketchybar --set "$NAME" \
    icon="$ICON" \
    icon.color="$COLOR" \
    label="$LABEL" \
    label.color="$COLOR"
