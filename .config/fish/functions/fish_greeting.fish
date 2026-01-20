function fish_greeting
    # Only show fastfetch in main terminal, not tmux panes or new tabs
    if not set -q TMUX; and test "$TERM_PROGRAM" != "tmux"
        fastfetch
    end
end
