#!/bin/bash
slot=$1
session=$(tmux display-message -p '#S')
file="$HOME/.config/tmux/harpoon"

# Ensure file has enough lines
while [ $(wc -l < "$file" 2>/dev/null || echo 0) -lt 5 ]; do
  echo "" >> "$file"
done

# Replace the line at slot position
sed -i '' "${slot}s/.*/${session}/" "$file"
tmux display-message "Harpooned '$session' to slot $slot"
