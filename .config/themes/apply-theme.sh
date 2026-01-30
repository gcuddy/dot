#!/bin/bash
# Apply theme by processing templates with color values
# Usage: apply-theme.sh <colors-file>

set -e

COLORS_FILE="$1"
TEMPLATES_DIR="$HOME/.config/themes/templates"
OUTPUT_DIR="$HOME/.config/themes/current"

if [[ ! -f "$COLORS_FILE" ]]; then
    echo "Error: Colors file not found: $COLORS_FILE" >&2
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build sed script from colors file
sed_script=$(mktemp)

# Parse TOML: convert 'key = "value"' to sed substitutions
while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs | tr -d '"')

    # Skip if key or value is empty
    [[ -z "$key" || -z "$value" ]] && continue

    # Add sed substitution
    echo "s|{{ ${key} }}|${value}|g" >> "$sed_script"
done < "$COLORS_FILE"

# Process each template
for tpl in "$TEMPLATES_DIR"/*.tpl; do
    [[ -f "$tpl" ]] || continue

    filename=$(basename "$tpl" .tpl)
    output_path="$OUTPUT_DIR/$filename"

    sed -f "$sed_script" "$tpl" > "$output_path"
    echo "Generated: $filename"
done

rm "$sed_script"

# Store current theme info
cp "$COLORS_FILE" "$OUTPUT_DIR/colors.toml"
grep -E "^name\s*=" "$COLORS_FILE" | head -1 | sed 's/^name[[:space:]]*=[[:space:]]*"\(.*\)"/\1/' > "$OUTPUT_DIR/theme.name"
grep -E "^appearance\s*=" "$COLORS_FILE" | head -1 | sed 's/^appearance[[:space:]]*=[[:space:]]*"\(.*\)"/\1/' > "$OUTPUT_DIR/theme.appearance"

# Apply borders theme and restart
BORDERS_THEME="$OUTPUT_DIR/bordersrc"
BORDERS_CONF="$HOME/.config/borders/bordersrc"

if [[ -f "$BORDERS_THEME" ]]; then
    cp "$BORDERS_THEME" "$BORDERS_CONF"
    # Restart borders if running
    if pgrep -x borders &>/dev/null; then
        brew services restart borders 2>/dev/null || killall borders 2>/dev/null
        echo "borders restarted"
    fi
fi

# Apply btop theme
BTOP_THEME="$OUTPUT_DIR/btop.theme"
BTOP_THEMES_DIR="$HOME/.config/btop/themes"
BTOP_CONF="$HOME/.config/btop/btop.conf"

if [[ -f "$BTOP_THEME" && -d "$BTOP_THEMES_DIR" ]]; then
    cp "$BTOP_THEME" "$BTOP_THEMES_DIR/current.theme"
    # Update btop.conf to use "current" theme
    if [[ -f "$BTOP_CONF" ]]; then
        sed -i '' 's/^color_theme = .*/color_theme = "current"/' "$BTOP_CONF"
        echo "btop theme applied"
    fi
fi

# Apply Chrome/Chromium theme via managed preferences (requires sudo)
CHROME_THEME_PLIST="$OUTPUT_DIR/chrome-theme.plist"
MANAGED_PREFS_DIR="/Library/Managed Preferences"

if [[ -f "$CHROME_THEME_PLIST" ]]; then
    echo "Applying Chrome browser theme..."
    
    # Check if we can write to managed prefs (need sudo)
    if [[ -w "$MANAGED_PREFS_DIR" ]] || sudo -n true 2>/dev/null; then
        # Merge with existing Chrome managed prefs or create new
        CHROME_MANAGED="$MANAGED_PREFS_DIR/com.google.Chrome.plist"
        
        if [[ -f "$CHROME_MANAGED" ]]; then
            # Read existing plist, update BrowserThemeColor
            THEME_COLOR=$(plutil -extract BrowserThemeColor raw "$CHROME_THEME_PLIST" 2>/dev/null)
            sudo plutil -replace BrowserThemeColor -string "$THEME_COLOR" "$CHROME_MANAGED" 2>/dev/null || \
            sudo plutil -insert BrowserThemeColor -string "$THEME_COLOR" "$CHROME_MANAGED" 2>/dev/null
        else
            sudo cp "$CHROME_THEME_PLIST" "$CHROME_MANAGED"
        fi
        echo "  Chrome managed preferences updated (restart Chrome to apply)"
    else
        echo "  Skipping Chrome theme (requires sudo). Run manually:"
        echo "    sudo cp '$CHROME_THEME_PLIST' '$MANAGED_PREFS_DIR/com.google.Chrome.plist'"
    fi
fi

# Copy tmux theme and reload
TMUX_THEME="$OUTPUT_DIR/tmux.conf"
TMUX_CURRENT="$HOME/.config/tmux/theme-current.conf"

if [[ -f "$TMUX_THEME" ]]; then
    cp "$TMUX_THEME" "$TMUX_CURRENT"
    # Reload tmux if running
    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
        tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null
        echo "tmux theme reloaded"
    fi
fi

# Reload Ghostty via menu (SIGUSR1 can cause issues)
if pgrep -x ghostty &>/dev/null; then
    osascript -e 'tell application "System Events" to tell process "Ghostty" to click menu item "Reload Configuration" of menu "Ghostty" of menu bar item "Ghostty" of menu bar 1' 2>/dev/null
    echo "ghostty config reloaded"
fi

echo "Theme applied successfully"
