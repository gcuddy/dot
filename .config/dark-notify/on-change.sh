#!/bin/bash
# Called by dark-notify when system appearance changes
# Argument: "dark" or "light"

MODE="$1"

# Update tmux theme
if [ -e "$HOME/.config/tmux/theme-$MODE.conf" ]; then
    ln -sf "$HOME/.config/tmux/theme-$MODE.conf" "$HOME/.config/tmux/theme-current.conf"
    # Reload all tmux sessions
    if command -v tmux &>/dev/null && tmux list-sessions &>/dev/null; then
        tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null
    fi
fi

# Update Claude Code theme
if command -v claude &>/dev/null; then
    claude config set --global theme "$MODE" 2>/dev/null
fi

# Update nvim instances (auto-dark-mode plugin will also detect this)
for addr in /tmp/nvim.*/0; do
    if [ -S "$addr" ]; then
        if [ "$MODE" = "light" ]; then
            nvim --server "$addr" --remote-send '<Cmd>set background=light<CR><Cmd>colorscheme alabaster<CR>' 2>/dev/null
        else
            nvim --server "$addr" --remote-send '<Cmd>set background=dark<CR><Cmd>colorscheme alabaster<CR>' 2>/dev/null
        fi
    fi
done

# Update lazygit theme (will apply on next launch)
if [ -e "$HOME/.config/lazygit/theme-$MODE.yml" ]; then
    ln -sf "$HOME/.config/lazygit/theme-$MODE.yml" "$HOME/.config/lazygit/theme-current.yml"
fi

# Update gh-dash theme (merge base + theme)
if [ -e "$HOME/.config/gh-dash/config-base.yml" ] && [ -e "$HOME/.config/gh-dash/theme-$MODE.yml" ]; then
    yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
        "$HOME/.config/gh-dash/config-base.yml" "$HOME/.config/gh-dash/theme-$MODE.yml" \
        > "$HOME/.config/gh-dash/config.yml"
fi
