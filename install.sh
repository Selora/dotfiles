#!/bin/bash

# Directory of current bash script
CWD=$PWD
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

XDG_CONFIG_HOME="$HOME/.config"

ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

mkdir -p $XDG_CONFIG_HOME/nix
echo "experimental-features = nix-command flakes" >>$XDG_CONFIG_HOME/nix/nix.conf

# Using the arch-os target is a best-effort automation to build the same environment on different arch
nix profile install $DOTFILES_DIR#packages.${ARCH}-${OS}
# Update so it gets rid of version conflict and always install the latest
nix profile upgrade ${ARCH}-${OS}

#nix build $DOTFILES_DIR

cd $DOTFILES_DIR
stow --adopt base

fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install PatrickF1/fzf.fish"

BLOCK='
# AUTO_FISH
# Start Fish only for interactive sessions
if [[ $- == *i* ]] && [ -x "$(command -v fish)" ]; then
  exec fish
fi
'
add_if_missing() {
  local file="$1"

  if [ -f "$file" ] && grep -q "# AUTO_FISH" "$file"; then
    echo "✅ $file already starts fish as default for interactive sessions, skipping."
  else
    echo "🔧 Adding fish as default for interactive sessions to $file..."
    echo "$BLOCK" >>"$file"
  fi
}

# Apply to .bashrc and .zshrc
add_if_missing "$HOME/.bashrc"
add_if_missing "$HOME/.zshrc"
