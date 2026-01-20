export PGHOST=localhost
export PGPORT=5432
export PGUSER=postgres_irm
export PGDATABASE=postgres_irm_dev

# fnm
export PATH="/Users/gus/Library/Application Support/fnm:$PATH"
eval "`fnm env`"

# pnpm
export PNPM_HOME="/Users/gus/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

. /opt/homebrew/opt/asdf/libexec/asdf.sh

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
