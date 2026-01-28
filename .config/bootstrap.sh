#!/bin/bash
# Bootstrap script for setting up a new Mac
# Run: curl -fsSL https://raw.githubusercontent.com/gcuddy/dot/main/.config/bootstrap.sh | bash

set -e

DOTFILES_REPO="https://github.com/gcuddy/dot.git"
DOTFILES_DIR="$HOME/.dot"

echo "==> Starting bootstrap..."

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to path for this session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

# Clone dotfiles as bare repo
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "==> Cloning dotfiles..."
    git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Function to run git commands against dotfiles
config() {
    /usr/bin/git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" "$@"
}

# Backup existing files that would conflict
echo "==> Checking for conflicts..."
config checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | while read -r file; do
    if [[ -f "$HOME/$file" ]]; then
        echo "    Backing up $file to $file.bak"
        mv "$HOME/$file" "$HOME/$file.bak"
    fi
done

# Checkout dotfiles
echo "==> Checking out dotfiles..."
config checkout

# Hide untracked files in status
config config status.showUntrackedFiles no

# Install brew packages
if [[ -f "$HOME/.config/Brewfile" ]]; then
    echo "==> Installing brew packages..."
    brew bundle --file="$HOME/.config/Brewfile"
fi

# Set fish as default shell
FISH_PATH="$(which fish)"
if [[ -n "$FISH_PATH" ]] && ! grep -q "$FISH_PATH" /etc/shells; then
    echo "==> Adding fish to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$FISH_PATH" ]]; then
    echo "==> Setting fish as default shell..."
    chsh -s "$FISH_PATH"
fi

# Install tmux plugin manager
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo "==> Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Install fisher (fish plugin manager)
if command -v fish &>/dev/null; then
    echo "==> Installing fisher..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher" 2>/dev/null || true

    # Install fish plugins from fish_plugins file
    if [[ -f "$HOME/.config/fish/fish_plugins" ]]; then
        echo "==> Installing fish plugins..."
        fish -c "fisher update" 2>/dev/null || true
    fi
fi

echo ""
echo "==> Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  1. Open a new terminal (or run: exec fish)"
echo "  2. Run 'tmux' and press prefix + I to install tmux plugins"
echo "  3. Open nvim and let lazy.nvim install plugins"
echo ""
