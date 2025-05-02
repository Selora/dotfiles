#!/bin/bash

echo -e "\033[1;36m"
echo "╔════════════════════════════════════╗"
echo "║           🚀 Selora's  🚀          ║"
echo "║    Main host Installation Script   ║"
echo "╚════════════════════════════════════╝"
echo -e "\033[0m"
#
# Directory of current bash script
CWD=$PWD
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "**************************************"
echo "* Setting nix config and exporting nix-profile to $HOME/profile"

ARCH=$(uname -m)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

# Ensure ~/.nix-profile/bin is in PATH for this script
export PATH="$HOME/.nix-profile/bin:$PATH"

mkdir -p $XDG_CONFIG_HOME/nix
#echo "experimental-features = nix-command flakes" >>$XDG_CONFIG_HOME/nix/nix.conf
grep -qxF "experimental-features = nix-command flakes" "$XDG_CONFIG_HOME/nix/nix.conf" || echo "experimental-features = nix-command flakes" >>"$XDG_CONFIG_HOME/nix/nix.conf"

# Ensure ~/.nix-profile/bin is in PATH for this script
export PATH="$HOME/.nix-profile/bin:$PATH"

export FLAKE_PATH="${DOTFILES_DIR}/main_host/nix"
echo $FLAKE_PATH

echo "**************************************"
echo "* Installing Nix flake @$FLAKE_PATH#packages_main_host.${ARCH}-${OS}"
# Using the arch-os target is a best-effort automation to build the same environment on different arch
nix profile install $FLAKE_PATH#packages_main_host.${ARCH}-${OS}
# Update so it gets rid of version conflict and always install the latest
nix profile upgrade main_host/nix

echo "**************************************"
echo "* Pushing main_host dotfiles         *"

cd $DOTFILES_DIR
stow main_host

echo -e "\033[1;32m"
echo "✅ Dotfiles for daily-driver installation complete!"
echo "🔥 Your environment is now ready."
echo -e "\033[0m"
