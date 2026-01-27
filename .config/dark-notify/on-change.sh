#!/bin/bash
# Called by dark-notify when system appearance changes
# Argument: "dark" or "light"

MODE="$1"
THEMES_DIR="$HOME/.config/themes"
CURRENT_DIR="$THEMES_DIR/current"
COLORS_DIR="$THEMES_DIR/colors"

# Get current theme base name
THEME_BASE="alabaster"
if [[ -f "$CURRENT_DIR/theme.base" ]]; then
    THEME_BASE=$(cat "$CURRENT_DIR/theme.base")
fi

# Find colors file
COLORS_FILE=""
if [[ -f "$COLORS_DIR/${THEME_BASE}-${MODE}.toml" ]]; then
    COLORS_FILE="$COLORS_DIR/${THEME_BASE}-${MODE}.toml"
elif [[ -f "$COLORS_DIR/${THEME_BASE}.toml" ]]; then
    COLORS_FILE="$COLORS_DIR/${THEME_BASE}.toml"
fi

if [[ -z "$COLORS_FILE" ]]; then
    echo "No colors file found for $THEME_BASE $MODE"
    exit 1
fi

# Generate configs from templates
"$THEMES_DIR/apply-theme.sh" "$COLORS_FILE"

# Apply to apps

# Ghostty - install theme
if [[ -f "$CURRENT_DIR/ghostty" ]]; then
    cp "$CURRENT_DIR/ghostty" "$HOME/.config/ghostty/themes/${THEME_BASE}-${MODE}"
fi

# Tmux - copy and reload
if [[ -f "$CURRENT_DIR/tmux.conf" ]]; then
    cp "$CURRENT_DIR/tmux.conf" "$HOME/.config/tmux/theme-current.conf"
    if pgrep -x tmux >/dev/null; then
        tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null
    fi
fi

# Lazygit - copy theme
if [[ -f "$CURRENT_DIR/lazygit.yml" ]]; then
    cp "$CURRENT_DIR/lazygit.yml" "$HOME/.config/lazygit/theme-current.yml"
fi

# gh-dash - merge configs
if [[ -f "$CURRENT_DIR/gh-dash.yml" ]] && [[ -f "$HOME/.config/gh-dash/config-base.yml" ]]; then
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
        "$HOME/.config/gh-dash/config-base.yml" "$CURRENT_DIR/gh-dash.yml" \
        > "$HOME/.config/gh-dash/config.yml"
fi

# Claude Code
if command -v claude &>/dev/null; then
    claude config set --global theme "$MODE" 2>/dev/null
fi

# Neovim - update running instances
NVIM_COLORSCHEME="$THEME_BASE"
case "$THEME_BASE" in
    "tokyo-night") NVIM_COLORSCHEME="tokyonight" ;;
    "kanagawa") NVIM_COLORSCHEME="kanagawa" ;;
    "alabaster") NVIM_COLORSCHEME="alabaster" ;;
    "gruvbox") NVIM_COLORSCHEME="gruvbox" ;;
    "catppuccin-macchiato") NVIM_COLORSCHEME="catppuccin-macchiato" ;;
esac

for addr in /tmp/nvim.*/0; do
    if [[ -S "$addr" ]]; then
        nvim --server "$addr" --remote-send "<Cmd>set background=$MODE<CR><Cmd>colorscheme $NVIM_COLORSCHEME<CR>" 2>/dev/null
    fi
done
