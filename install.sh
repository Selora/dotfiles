#!/bin/bash

echo -e "\033[1;36m"
echo "╔════════════════════════════════════╗"
echo "║           🚀 Selora's  🚀          ║"
echo "║    Dotfiles Installation Script    ║"
echo "║   Setting up your environment...   ║"
echo "╚════════════════════════════════════╝"
echo -e "\033[0m"

# Directory of current bash script
CWD=$PWD
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

XDG_CONFIG_HOME="$HOME/.config"

ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

echo "**************************************"
echo "* Setting nix config and exporting nix-profile to $HOME/profile"

mkdir -p $XDG_CONFIG_HOME/nix
#echo "experimental-features = nix-command flakes" >>$XDG_CONFIG_HOME/nix/nix.conf
grep -qxF "experimental-features = nix-command flakes" "$XDG_CONFIG_HOME/nix/nix.conf" || echo "experimental-features = nix-command flakes" >>"$XDG_CONFIG_HOME/nix/nix.conf"

# Ensure ~/.nix-profile/bin is in PATH for this script
export PATH="$HOME/.nix-profile/bin:$PATH"

export FLAKE_PATH="${DOTFILES_DIR}/base/nix"
echo $FLAKE_PATH

echo "**************************************"
echo "* Installing Nix flake @$FLAKE_PATH#packages.${ARCH}-${OS}"
# Using the arch-os target is a best-effort automation to build the same environment on different arch
nix profile install $FLAKE_PATH#packages.${ARCH}-${OS}
# Update so it gets rid of version conflict and always install the latest
nix profile upgrade base/nix

#nix build $DOTFILES_DIR

cd $DOTFILES_DIR
stow --adopt base

fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fish -c "fisher install PatrickF1/fzf.fish"

BLOCK='
# AUTO_FISH
# Start Fish only for interactive sessions
PATH=$HOME/.nix-profile/bin:$PATH
if [[ $- == *i* ]] && [ -x "$(command -v fish)" ]; then
  exec fish
else
  echo "⚠️ Fish shell not found, falling back to default shell."
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

# Install terminfo
tempfile=$(mktemp) &&
  curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
  tic -x -o ~/.terminfo $tempfile &&
  rm $tempfile

echo -e "\033[1;32m"
echo "✅ Dotfiles installation complete!"
echo "🔥 Your environment is now ready."
echo -e "\033[0m"
