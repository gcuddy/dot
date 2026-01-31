#!/bin/bash
# Apply theme by processing templates with color values
# Usage: apply-theme.sh <colors-file>

set -e

COLORS_FILE="$1"
THEMES_DIR="$HOME/.config/themes"
TEMPLATES_DIR="$THEMES_DIR/templates"
OUTPUT_DIR="$THEMES_DIR/current"

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
THEME_NAME=$(grep -E "^name\s*=" "$COLORS_FILE" | head -1 | sed 's/^name[[:space:]]*=[[:space:]]*"\(.*\)"/\1/')
APPEARANCE=$(grep -E "^appearance\s*=" "$COLORS_FILE" | head -1 | sed 's/^appearance[[:space:]]*=[[:space:]]*"\(.*\)"/\1/')
echo "$THEME_NAME" > "$OUTPUT_DIR/theme.name"
echo "$APPEARANCE" > "$OUTPUT_DIR/theme.appearance"

# Extract base theme name (e.g., "gruvbox" from "gruvbox-dark.toml")
BASENAME=$(basename "$COLORS_FILE" .toml | sed 's/-\(dark\|light\)$//')
echo "$BASENAME" > "$OUTPUT_DIR/theme.base"

echo ""
echo "Installing configs..."

# Borders - copy and restart
if [[ -f "$OUTPUT_DIR/bordersrc" ]]; then
    cp "$OUTPUT_DIR/bordersrc" "$HOME/.config/borders/bordersrc"
    chmod +x "$HOME/.config/borders/bordersrc"
    if pgrep -x borders &>/dev/null; then
        pkill -x borders
        sleep 0.2
        nohup "$HOME/.config/borders/bordersrc" &>/dev/null &
        disown
    fi
    echo "  borders: updated"
fi

# btop - copy theme
if [[ -f "$OUTPUT_DIR/btop.theme" && -d "$HOME/.config/btop/themes" ]]; then
    cp "$OUTPUT_DIR/btop.theme" "$HOME/.config/btop/themes/current.theme"
    if [[ -f "$HOME/.config/btop/btop.conf" ]]; then
        sed -i '' 's/^color_theme = .*/color_theme = "current"/' "$HOME/.config/btop/btop.conf"
    fi
    echo "  btop: updated"
fi

# tmux - copy and reload
if [[ -f "$OUTPUT_DIR/tmux.conf" ]]; then
    cp "$OUTPUT_DIR/tmux.conf" "$HOME/.config/tmux/theme-current.conf"
    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null 2>&1; then
        tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null
    fi
    echo "  tmux: updated"
fi

# lazygit - merge with base config
if [[ -f "$OUTPUT_DIR/lazygit.yml" && -f "$HOME/.config/lazygit/config-base.yml" ]]; then
    cp "$OUTPUT_DIR/lazygit.yml" "$HOME/.config/lazygit/theme-current.yml"
    if command -v yq &>/dev/null; then
        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
            "$HOME/.config/lazygit/config-base.yml" "$OUTPUT_DIR/lazygit.yml" \
            > "$HOME/.config/lazygit/config.yml"
        echo "  lazygit: updated (restart to apply)"
    else
        echo "  lazygit: skipped (yq not found)"
    fi
fi

# gh-dash - merge with base config
if [[ -f "$OUTPUT_DIR/gh-dash.yml" && -f "$HOME/.config/gh-dash/config-base.yml" ]]; then
    if command -v yq &>/dev/null; then
        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
            "$HOME/.config/gh-dash/config-base.yml" "$OUTPUT_DIR/gh-dash.yml" \
            > "$HOME/.config/gh-dash/config.yml"
        echo "  gh-dash: updated (restart to apply)"
    else
        cp "$OUTPUT_DIR/gh-dash.yml" "$HOME/.config/gh-dash/theme-current.yml"
        echo "  gh-dash: updated (yq not found, copied as theme-current.yml)"
    fi
fi

# Ghostty - reload config
if pgrep -x ghostty &>/dev/null; then
    osascript -e 'tell application "System Events" to tell process "Ghostty" to click menu item "Reload Configuration" of menu "Ghostty" of menu bar item "Ghostty" of menu bar 1' &>/dev/null || true
    echo "  ghostty: reloaded"
fi

# Neovim - copy theme config and update running instances
NVIM_THEME_SRC="$THEMES_DIR/neovim/$BASENAME.lua"
NVIM_THEME_DST="$HOME/.config/nvim/lua/plugins/theme-current.lua"
if [[ -f "$NVIM_THEME_SRC" ]]; then
    cp "$NVIM_THEME_SRC" "$NVIM_THEME_DST"
    echo "  nvim: theme config copied (restart nvim to apply new plugins)"
fi

# Also update running nvim instances with colorscheme
if [[ -f "$OUTPUT_DIR/nvim-colorscheme" ]]; then
    NVIM_COLORSCHEME=$(cat "$OUTPUT_DIR/nvim-colorscheme")
    TMPDIR_CLEAN=$(echo "${TMPDIR:-/tmp}" | sed 's:/$::')
    
    for addr in "$TMPDIR_CLEAN"/nvim.*/0 /tmp/nvim.*/0; do
        if [[ -S "$addr" ]]; then
            nvim --server "$addr" --remote-send "<Cmd>set background=$APPEARANCE<CR><Cmd>colorscheme $NVIM_COLORSCHEME<CR>" 2>/dev/null || true
        fi
    done
    echo "  nvim: colorscheme updated ($NVIM_COLORSCHEME)"
fi

# Claude Code - set theme mode
if command -v claude &>/dev/null; then
    claude config set --global theme "$APPEARANCE" &>/dev/null || true
    echo "  claude: set to $APPEARANCE"
fi

# Obsidian - update appearance.json in all vaults
OBSIDIAN_CONFIG="$HOME/Library/Application Support/obsidian/obsidian.json"
if [[ -f "$OBSIDIAN_CONFIG" ]]; then
    # Get all vault paths
    vault_paths=$(jq -r '.vaults | to_entries[] | .value.path' "$OBSIDIAN_CONFIG" 2>/dev/null)
    obsidian_updated=0
    while IFS= read -r vault_path; do
        appearance_file="$vault_path/.obsidian/appearance.json"
        if [[ -f "$appearance_file" ]]; then
            # Update theme to match appearance (light/dark)
            jq --arg theme "$APPEARANCE" '.theme = $theme' "$appearance_file" > "$appearance_file.tmp" && \
                mv "$appearance_file.tmp" "$appearance_file"
            obsidian_updated=$((obsidian_updated + 1))
        fi
    done <<< "$vault_paths"
    if [[ $obsidian_updated -gt 0 ]]; then
        echo "  obsidian: updated $obsidian_updated vault(s) to $APPEARANCE mode"
    fi
fi

# Wallpaper - set desktop background from theme backgrounds
BACKGROUNDS_DIR="$THEMES_DIR/backgrounds/$BASENAME"
if [[ -d "$BACKGROUNDS_DIR" ]]; then
    # Find images (jpg, jpeg, png) sorted alphabetically, pick first one
    WALLPAPER=$(find "$BACKGROUNDS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort | head -1)
    if [[ -n "$WALLPAPER" ]]; then
        # Store current wallpaper path for reference
        echo "$WALLPAPER" > "$OUTPUT_DIR/wallpaper"
        
        # Set wallpaper on macOS
        osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"$WALLPAPER\"" 2>/dev/null || true
        echo "  wallpaper: $(basename "$WALLPAPER")"
    fi
else
    echo "  wallpaper: no backgrounds found for $BASENAME"
fi

# Chrome - requires sudo, just show instructions
if [[ -f "$OUTPUT_DIR/chrome-theme.plist" ]]; then
    if sudo -n true 2>/dev/null; then
        CHROME_MANAGED="/Library/Managed Preferences/com.google.Chrome.plist"
        THEME_COLOR=$(plutil -extract BrowserThemeColor raw "$OUTPUT_DIR/chrome-theme.plist" 2>/dev/null)
        if [[ -f "$CHROME_MANAGED" ]]; then
            sudo plutil -replace BrowserThemeColor -string "$THEME_COLOR" "$CHROME_MANAGED" 2>/dev/null || \
            sudo plutil -insert BrowserThemeColor -string "$THEME_COLOR" "$CHROME_MANAGED" 2>/dev/null
        else
            sudo cp "$OUTPUT_DIR/chrome-theme.plist" "$CHROME_MANAGED"
        fi
        echo "  chrome: updated (restart to apply)"
    else
        echo "  chrome: skipped (run: sudo ~/.config/themes/apply-chrome-theme.sh)"
    fi
fi

# SketchyBar - copy colors and reload
if [[ -f "$OUTPUT_DIR/sketchybar-colors.sh" ]]; then
    cp "$OUTPUT_DIR/sketchybar-colors.sh" "$HOME/.config/sketchybar/theme-colors.sh"
    chmod +x "$HOME/.config/sketchybar/theme-colors.sh"
    if pgrep -x sketchybar &>/dev/null; then
        sketchybar --reload
    fi
    echo "  sketchybar: updated"
fi

echo ""
echo "Theme applied: $THEME_NAME ($APPEARANCE)"
