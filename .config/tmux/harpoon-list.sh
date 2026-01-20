#!/bin/bash
file="$HOME/.config/tmux/harpoon"

echo "Harpooned Sessions"
echo "──────────────────"
awk '{printf "%d: %s\n", NR, ($0 == "" ? "(empty)" : $0)}' "$file" | head -5
echo ""
echo "Press any key to close"
read -n 1
