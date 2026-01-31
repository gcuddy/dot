function theme --description "Switch themes (usage: theme [name] [light|dark])"
    set -l themes_dir ~/.config/themes
    set -l colors_dir $themes_dir/colors
    set -l current_dir $themes_dir/current

    # Parse arguments
    set -l theme_name ""
    set -l mode ""

    for arg in $argv
        switch $arg
            case list -l
                echo "Available themes:"
                for f in $colors_dir/*.toml
                    echo "  "(basename $f .toml)
                end
                return 0
            case current status
                cat $current_dir/theme.name 2>/dev/null || echo "No theme set"
                return 0
            case light dark
                set mode $arg
            case '*'
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

    # If no theme name, use current or default
    if test -z "$theme_name"
        if test -f $current_dir/theme.base
            set theme_name (cat $current_dir/theme.base | string trim)
        end
        if test -z "$theme_name"
            set theme_name "gruvbox"
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
        echo "Try: theme list"
        return 1
    end

    # Apply theme
    $themes_dir/apply-theme.sh "$colors_file"
end
