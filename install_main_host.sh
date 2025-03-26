#!/bin/bash

echo -e "\033[1;36m"
echo "╔════════════════════════════════════╗"
echo "║           🚀 Selora's  🚀          ║"
echo "║    Main host Installation Script   ║"
echo "╚════════════════════════════════════╝"
echo -e "\033[0m"

# Directory of current bash script
CWD=$PWD
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

cd $DOTFILES_DIR
stow main_host
