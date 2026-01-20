set -gx TERM xterm-256color
set -gx EDITOR nvim
set -gx PROJECTS /Users/gus/Development

set -gx fish_vi_force_cursor 1
set -gx fish_cursor_default block
set -gx fish_cursor_insert line blink
set -gx fish_cursor_visual block
set -gx fish_cursor_replace_one underscore

# PATH - consolidated
set -gx PATH ~/bin ~/.local/bin bin $PATH
set -gx PNPM_HOME /Users/gus/Library/pnpm
set -gx BUN_INSTALL "$HOME/.bun"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $BUN_INSTALL/bin $PATH
end

# asdf (handles its own paths)
source ~/.asdf/asdf.fish

# Lazy-load pyenv (saves ~85ms on startup)
function pyenv
    functions -e pyenv
    pyenv init - fish | source
    pyenv $argv
end

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
alias claude="/Users/gus/.claude/local/claude"

# coverbase specific aliases
alias test:api "docker exec dev-api.irm.cb.local pytest"
alias test:tasker "docker exec dev-tasker.irm.cb.local pytest"
alias test:common "docker exec dev-common-test pytest"
alias alembic:run "docker exec dev-api.irm.cb.local alembic -c /irm/common/alembic.ini"
alias tasker:python "docker exec -it dev-tasker.irm.cb.local python"

# Abbreviations
abbr g hub
abbr git hub
abbr ghc "gh co"
abbr gg lazygit
abbr gl 'hub l --color | devmoji --log --color | less -rXF'
abbr gs "hub st"
abbr gb "hub checkout -b"
abbr gc "hub commit"
abbr gpr "hub pr checkout"
abbr gm "hub branch -l main | rg main > /dev/null 2>&1 && hub checkout main || hub checkout master"
abbr gcm "hub checkout main --"
abbr gcp "hub commit -p"
abbr gpp "hub push"
abbr gp "hub pull"
abbr glc "gh run list --workflow=pulumi-up.yml --limit=1 --json headSha --jq '.[0].headSha'"
abbr s "source $HOME/.config/fish/config.fish"
abbr mv "mv -iv"
abbr cp "cp -riv"
abbr mkdir "mkdir -vp"
abbr l ll
abbr ncdu "ncdu --color dark"
abbr vi nvim
abbr v nvim
abbr t tmux
abbr ta 'tmux attach -t'
abbr tad 'tmux attach -d -t'
abbr ts 'tmux new -s'
abbr tl 'tmux ls'
abbr tk 'tmux kill-session -t'

# Interactive shell setup
if status is-interactive
    atuin init fish --disable-up-arrow | source
    zoxide init fish | source
end

# OrbStack (only if installed)
test -f ~/.orbstack/shell/init2.fish && source ~/.orbstack/shell/init2.fish
