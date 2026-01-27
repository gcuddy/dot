function theme --description "Switch themes (usage: theme [name] [light|dark])"
    set -l themes_dir ~/.config/themes
    set -l colors_dir $themes_dir/colors
    set -l current_dir $themes_dir/current

    # Parse arguments
    set -l theme_name ""
    set -l mode ""

    for arg in $argv
        if test "$arg" = "light" -o "$arg" = "dark"
            set mode $arg
        else if test "$arg" = "list" -o "$arg" = "-l"
            echo "Available themes:"
            for f in $colors_dir/*.toml
                set -l name (basename $f .toml)
                echo "  $name"
            end
            return 0
        else
            set theme_name $arg
        end
    end

    # Auto-detect mode from system if not specified
    if test -z "$mode"
        set -l sys_mode (defaults read -g AppleInterfaceStyle 2>/dev/null || echo "Light")
        if test "$sys_mode" = "Dark"
            set mode "dark"
        else
            set mode "light"
        end
    end

    # If no theme name, try to get current theme base name
    if test -z "$theme_name"
        if test -f $current_dir/theme.base
            set theme_name (cat $current_dir/theme.base 2>/dev/null | string trim)
        end
        if test -z "$theme_name"
            set theme_name "alabaster"
        end
    end

    # Normalize theme name
    set theme_name (echo $theme_name | string lower | string replace -a ' ' '-')

    # Find the colors file (try theme-mode first, then just theme)
    set -l colors_file ""
    if test -f "$colors_dir/$theme_name-$mode.toml"
        set colors_file "$colors_dir/$theme_name-$mode.toml"
    else if test -f "$colors_dir/$theme_name.toml"
        set colors_file "$colors_dir/$theme_name.toml"
    else
        echo "Theme not found: $theme_name"
        echo "Available themes:"
        for f in $colors_dir/*.toml
            echo "  "(basename $f .toml)
        end
        return 1
    end

    echo "Applying theme: $theme_name ($mode mode)"

    # Generate configs from templates
    $themes_dir/apply-theme.sh "$colors_file"

    # Apply to each app
    echo ""
    echo "Installing configs..."

    # Ghostty - copy to themes dir, update config
    if test -f $current_dir/ghostty
        set -l ghostty_theme_name "$theme_name-$mode"
        cp $current_dir/ghostty ~/.config/ghostty/themes/$ghostty_theme_name
        # Update ghostty config to use this theme (for both light and dark)
        set -l light_theme "$theme_name-light"
        set -l dark_theme "$theme_name-dark"
        sed -i '' "s/^theme = .*/theme = light:$light_theme,dark:$dark_theme/" ~/.config/ghostty/config 2>/dev/null
        echo "  Ghostty: installed theme '$ghostty_theme_name'"
    end

    # Tmux - copy to tmux dir
    if test -f $current_dir/tmux.conf
        cp $current_dir/tmux.conf ~/.config/tmux/theme-current.conf
        if test -n "$TMUX"
            tmux source-file ~/.config/tmux/tmux.conf 2>/dev/null
        end
        echo "  Tmux: updated"
    end

    # Lazygit - copy theme file
    if test -f $current_dir/lazygit.yml
        cp $current_dir/lazygit.yml ~/.config/lazygit/theme-current.yml
        echo "  Lazygit: updated (restart to apply)"
    end

    # gh-dash - merge with base config
    if test -f $current_dir/gh-dash.yml -a -f ~/.config/gh-dash/config-base.yml
        yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
            ~/.config/gh-dash/config-base.yml $current_dir/gh-dash.yml \
            > ~/.config/gh-dash/config.yml
        echo "  gh-dash: updated (restart to apply)"
    end

    # Claude Code
    if command -v claude >/dev/null
        claude config set --global theme $mode 2>/dev/null
        echo "  Claude Code: set to $mode"
    end

    # Neovim - update via remote if possible, also update auto-dark-mode config
    set -l nvim_colorscheme $theme_name
    # Map theme names to nvim colorscheme names
    switch $theme_name
        case "tokyo-night"
            set nvim_colorscheme "tokyonight"
        case "kanagawa"
            set nvim_colorscheme "kanagawa"
        case "alabaster"
            set nvim_colorscheme "alabaster"
        case "gruvbox"
            set nvim_colorscheme "gruvbox"
        case "catppuccin-macchiato"
            set nvim_colorscheme "catppuccin-macchiato"
    end

    for addr in (find /tmp -name 'nvim.*' -type s 2>/dev/null)
        nvim --server "$addr" --remote-send "<Cmd>set background=$mode<CR><Cmd>colorscheme $nvim_colorscheme<CR>" 2>/dev/null
    end
    echo "  Neovim: set to $nvim_colorscheme ($mode)"

    # Save current theme for persistence
    echo "$theme_name" > $current_dir/theme.base

    echo ""
    echo "Done! Some apps may need restart. Ghostty needs new window or restart."
end
