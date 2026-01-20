# Dotfiles management wrapper
# Adds 'config untracked' to see what's not tracked in .config

function config
    if test "$argv[1]" = "lg"
        lazygit --git-dir=$HOME/.dot --work-tree=$HOME
    else if test "$argv[1]" = "add-new"
        # Add all new files in tracked directories
        for f in (config new)
            command git --git-dir=$HOME/.dot --work-tree=$HOME add $f
            echo "Added $f"
        end
    else if test "$argv[1]" = "new"
        # Show new (untracked) files in tracked directories
        # Usage: config new [directory]  (e.g., config new themes)
        if test (count $argv) -gt 1
            # Check specific directory
            cd $HOME && /usr/bin/git --git-dir=$HOME/.dot --work-tree=$HOME ls-files --others --exclude-standard .config/$argv[2]/
        else
            # Check core tracked directories only
            set -l core_dirs fish nvim tmux ghostty lazygit git bat btop aerospace karabiner atuin themes dark-notify starship.toml amp gh gh-dash mise
            for dir in $core_dirs
                cd $HOME && /usr/bin/git --git-dir=$HOME/.dot --work-tree=$HOME ls-files --others --exclude-standard .config/$dir 2>/dev/null
            end
        end
    else if test "$argv[1]" = "untracked"
        # Show top-level untracked items in .config (must run from $HOME)
        set -l tracked
        for file in (cd $HOME && /usr/bin/git --git-dir=$HOME/.dot --work-tree=$HOME ls-files .config/)
            set -l dir (string replace '.config/' '' $file | string split '/' -f1)
            if not contains $dir $tracked
                set -a tracked $dir
            end
        end
        for item in (command ls -1 $HOME/.config)
            if not contains $item $tracked
                echo $item
            end
        end
    else
        command git --git-dir=$HOME/.dot --work-tree=$HOME $argv
    end
end
