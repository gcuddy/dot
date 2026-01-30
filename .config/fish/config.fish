set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"
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
# config function is in functions/config.fish

# coverbase specific aliases
alias test:api "docker exec dev-api.irm.cb.local pytest"
alias test:tasker "docker exec dev-tasker.irm.cb.local pytest"
alias test:common "docker exec dev-common-test pytest"
alias alembic:run "docker exec dev-api.irm.cb.local alembic -c /irm/common/alembic.ini"
alias tasker:python "docker exec -it dev-tasker.irm.cb.local python"

# Abbreviations
abbr -a oc opencode
abbr -a c clear
abbr -a pn pnpm
abbr -a g hub
abbr -a git hub
abbr -a ghc 'gh co'
abbr -a gg lazygit
abbr -a gl 'hub l --color | devmoji --log --color | less -rXF'
abbr -a gs 'hub st'
abbr -a gb 'hub checkout -b'
abbr -a gc 'hub commit'
abbr -a gpr 'hub pr checkout'
abbr -a gm 'hub branch -l main | rg main > /dev/null 2>&1 && hub checkout main || hub checkout master'
abbr -a gcm 'hub checkout main --'
abbr -a gcp 'hub commit -p'
abbr -a gpp 'hub push'
abbr -a gp 'hub pull'
abbr -a glc 'gh run list --workflow=pulumi-up.yml --limit=1 --json headSha --jq .[0].headSha'
abbr -a s 'source ~/.config/fish/config.fish'
abbr -a mv 'mv -iv'
abbr -a cp 'cp -riv'
abbr -a mkdir 'mkdir -vp'
abbr -a l ll
abbr -a ncdu 'ncdu --color dark'
abbr -a vi nvim
abbr -a v nvim
abbr -a t tmux
abbr -a ta 'tmux attach'
abbr -a tad 'tmux attach -d -t'
abbr -a ts 'tmux new -s'
abbr -a tl 'tmux ls'
abbr -a tk 'tmux kill-session -t'
abbr -a dc 'docker compose'
abbr -a dcu 'docker compose up -d'
abbr -a dcd 'docker compose down'
abbr -a dps 'docker ps'
abbr -a dlogs 'docker logs -f'

# Interactive shell setup - cached for speed (delete *.cached.fish to regenerate)
if status is-interactive
    set -l cache_dir ~/.config/fish/conf.d
    if not test -f $cache_dir/atuin.cached.fish
        atuin init fish --disable-up-arrow >$cache_dir/atuin.cached.fish
    end
    if not test -f $cache_dir/zoxide.cached.fish
        zoxide init fish >$cache_dir/zoxide.cached.fish
    end
    if not test -f $cache_dir/mise.cached.fish
        mise activate fish >$cache_dir/mise.cached.fish
    end
    source $cache_dir/atuin.cached.fish
    source $cache_dir/zoxide.cached.fish
    source $cache_dir/mise.cached.fish
end

# OrbStack (only if installed)
test -f ~/.orbstack/shell/init2.fish && source ~/.orbstack/shell/init2.fish
