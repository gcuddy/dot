#!/bin/bash
# Apply Chrome theme from current theme config
# Usage: sudo ./apply-chrome-theme.sh

set -e

THEME_PLIST="$HOME/.config/themes/current/chrome-theme.plist"
CHROME_MANAGED="/Library/Managed Preferences/com.google.Chrome.plist"

if [[ $EUID -ne 0 ]]; then
    echo "This script requires root. Run with: sudo $0"
    exit 1
fi

if [[ ! -f "$THEME_PLIST" ]]; then
    echo "Error: No theme plist found. Run apply-theme.sh first."
    exit 1
fi

THEME_COLOR=$(plutil -extract BrowserThemeColor raw "$THEME_PLIST")

if [[ -f "$CHROME_MANAGED" ]]; then
    # Try replace first, then insert if key doesn't exist
    plutil -replace BrowserThemeColor -string "$THEME_COLOR" "$CHROME_MANAGED" 2>/dev/null || \
    plutil -insert BrowserThemeColor -string "$THEME_COLOR" "$CHROME_MANAGED"
else
    cp "$THEME_PLIST" "$CHROME_MANAGED"
fi

echo "Chrome theme set to: $THEME_COLOR"
echo "Restart Chrome to apply."
