function theme --description "Switch between light and dark themes (tmux, Claude Code)"
    set -l mode $argv[1]

    # If no argument, detect current system appearance
    if test -z "$mode"
        set mode (defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
        if test "$mode" = "Dark"
            set mode "dark"
        else
            set mode "light"
        end
        echo "Detected system appearance: $mode"
    end

    # Validate mode
    if test "$mode" != "light" -a "$mode" != "dark"
        echo "Usage: theme [light|dark]"
        echo "If no argument, syncs with system appearance"
        return 1
    end

    echo "Switching to $mode mode..."

    # Update tmux theme
    if test -e ~/.config/tmux/theme-$mode.conf
        ln -sf ~/.config/tmux/theme-$mode.conf ~/.config/tmux/theme-current.conf
        # Reload tmux if running
        if test -n "$TMUX"
            tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null
            echo "  Tmux theme updated"
        else if pgrep -x tmux >/dev/null
            tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null
            echo "  Tmux theme updated"
        end
    end

    # Update Claude Code theme
    if command -v claude >/dev/null
        claude config set --global theme $mode 2>/dev/null
        echo "  Claude Code theme updated"
    end

    # Update nvim (auto-dark-mode will also pick this up within 1 second)
    for addr in (find /tmp -name 'nvim.*' -type s 2>/dev/null)
        if test "$mode" = "light"
            nvim --server "$addr" --remote-send '<Cmd>set background=light<CR><Cmd>colorscheme alabaster<CR>' 2>/dev/null
        else
            nvim --server "$addr" --remote-send '<Cmd>set background=dark<CR><Cmd>colorscheme alabaster<CR>' 2>/dev/null
        end
    end
    echo "  Neovim instances updated"

    # Update lazygit theme
    if test -e ~/.config/lazygit/theme-$mode.yml
        ln -sf ~/.config/lazygit/theme-$mode.yml ~/.config/lazygit/theme-current.yml
        echo "  Lazygit theme updated (restart lazygit to apply)"
    end

    # Update gh-dash theme (merge base + theme)
    if test -e ~/.config/gh-dash/config-base.yml -a -e ~/.config/gh-dash/theme-$mode.yml
        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
            ~/.config/gh-dash/config-base.yml ~/.config/gh-dash/theme-$mode.yml \
            > ~/.config/gh-dash/config.yml
        echo "  gh-dash theme updated (restart gh-dash to apply)"
    end

    echo "Done!"
end
