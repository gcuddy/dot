# Dotfiles management wrapper
# Adds 'config untracked' to see what's not tracked in .config

function config
    if test "$argv[1]" = "lg"
        lazygit --git-dir=$HOME/.dot --work-tree=$HOME
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
