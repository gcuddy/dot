# dotfiles

My dotfiles, managed with a bare git repo.

## What's included

- **fish** - Shell config, functions, completions
- **nvim** - Neovim config (LazyVim-based)
- **tmux** - Tmux config with catppuccin theme
- **ghostty** / **wezterm** - Terminal configs
- **starship** - Prompt
- **lazygit** - Git UI
- **git** - Git config and global ignores
- **bat** / **btop** - CLI tools
- **aerospace** - Window manager (macOS)
- **karabiner** - Keyboard remapping (macOS)
- **atuin** - Shell history

## Usage

### Daily workflow

```bash
# Check what's changed
config status

# Add changes
config add ~/.config/nvim/

# Commit
config commit -m "update nvim config"

# Push
config push
```

### Setup on a new machine

```bash
# Clone the bare repo
git clone --bare https://github.com/gcuddy/dot.git ~/.dot

# Define the alias
alias config='git --git-dir=$HOME/.dot --work-tree=$HOME'

# Checkout files
config checkout

# If there are conflicts with existing files:
# config checkout 2>&1 | grep -E "^\s+" | xargs -I{} mv {} {}.bak
# config checkout

# Hide untracked files from status
config config status.showUntrackedFiles no
```

### Adding new configs

```bash
config add ~/.config/new-app/
config commit -m "add new-app config"
config push
```

## Notes

- Secrets (`.env`, `.pgpass`, etc.) are gitignored
- Tmux plugins are not tracked - install with `prefix + I` after checkout
- The repo itself lives at `~/.dot` (bare repo)
