#!/bin/bash
TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"

# Ensure TPM is installed
if [ ! -d "$TMUX_PLUGIN_DIR/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR/tpm"
fi

# Remove old plugins
find "$TMUX_PLUGIN_DIR" -mindepth 1 -maxdepth 1 -type d ! -name "tpm" | xargs rm -rf

# Reinstall plugins
"$TMUX_PLUGIN_DIR/tpm/bin/install_plugins"

# Remove .git folders to freeze versions
find "$TMUX_PLUGIN_DIR" -type d -name .git | xargs rm -rf
