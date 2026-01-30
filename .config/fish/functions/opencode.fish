function opencode --description "opencode wrapper with tmux window restore"
    # Run opencode with all args, then restore automatic window naming
    command opencode $argv
    if set -q TMUX
        tmux set-window-option automatic-rename on
    end
end
