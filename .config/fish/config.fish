set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx PROJECTS /Users/gus/Development

set -gx fish_vi_force_cursor 1
set -gx fish_cursor_default block
set -gx fish_cursor_insert line blink
set -gx fish_cursor_visual block
set -gx fish_cursor_replace_one underscore

# PATH - consolidated (fish_add_path deduplicates automatically)
set -gx PNPM_HOME /Users/gus/Library/pnpm
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path -g ~/bin ~/.local/bin bin $PNPM_HOME $BUN_INSTALL/bin

# Python managed by uv (reads .python-version files automatically)

# Exports
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x PGHOST localhost
set -x PGPORT 5432
set -x PGUSER postgres_irm
set -x PGDATABASE postgres_irm_dev

# Aliases
alias ld lazydocker
command -qv nvim && alias vim nvim
alias lazygit "TERM=xterm-256color LG_CONFIG_FILE=$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/theme-current.yml command lazygit"
alias lg lazygit
alias ls="eza --color=always --icons --group-directories-first"
alias la='eza --color=always --icons --group-directories-first --all'
alias ll='eza --color=always --icons --group-directories-first --all --long'
alias c "open $1 -a \"Cursor\""
# config function is in functions/config.fish

# coverbase specific aliases
alias test:api "docker exec dev-api.irm.cb.local pytest"
alias test:tasker "docker exec dev-tasker.irm.cb.local pytest"
alias test:common "docker exec dev-common-test pytest"
alias alembic:run "docker exec dev-api.irm.cb.local alembic -c /irm/common/alembic.ini"
alias tasker:python "docker exec -it dev-tasker.irm.cb.local python"

# Abbreviations are universal - run `_setup_abbreviations` once if missing

# Interactive shell setup - cached for speed (delete *.cached.fish to regenerate)
if status is-interactive
    set -l cache_dir ~/.config/fish/conf.d
    if not test -f $cache_dir/atuin.cached.fish
        atuin init fish --disable-up-arrow > $cache_dir/atuin.cached.fish
    end
    if not test -f $cache_dir/zoxide.cached.fish
        zoxide init fish > $cache_dir/zoxide.cached.fish
    end
    if not test -f $cache_dir/mise.cached.fish
        mise activate fish > $cache_dir/mise.cached.fish
    end
    source $cache_dir/atuin.cached.fish
    source $cache_dir/zoxide.cached.fish
    source $cache_dir/mise.cached.fish
end

# OrbStack (only if installed)
test -f ~/.orbstack/shell/init2.fish && source ~/.orbstack/shell/init2.fish
