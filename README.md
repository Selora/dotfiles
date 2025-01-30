# Dotfiles

Battery-included Linux/Unix environment. Currently tested on `x86_64-linux` but should work on `aarch64-*` as well, and MacOS.

## Current features

- Non-invasive shell replacement with loaded `fish` shell.
- NeoVim (LazyVim) setup for remote development
- GNU utilities such as cat/ls/find/grep aliased to modern replacements
- Uses `nix`` flakes in a limited capacity to install all of this. The base OS is not polluted, and everything is installed as non-root in the`~/.nix-profile/bin` directory
- `nix` rollbacks: If an update breaks anything, rollback to the previous revision easily.
- Drop-in ready for a `devcontainer` workflow

## Installation

1. Install `nix`. This can be done through Homebrew on MacOS, or any linux distro package manager
2. `git clone https://github.com/Selora/dotfiles && sh dotfiles/install.sh`

High-level overview of the install script:

1. Install the dependencies listed `flake.nix`, and upgrade them if needed
2. Install fish plugins (because I'm not able to do it through nix, TODO)
3. Add the default shell, [see this section](#Notes_on_using_fish_as_a_default_shell)

### Adding tools, dependencies, etc

1. Go to <https://search.nixos.org/packages>
2. Look for the package you want, check the version, decide if you want it in unstable (more recent) or within a set release
3. In `flake.nix`, add the 'package name' (in the description in nixpkgs website) in the corresponding list (stable or unstable)
4. Re-run `install.sh`

## Notes on using `fish` as a default shell

Since `fish` is installed by `nix`, and the philosophy here is to avoid polluting the OS with anything and doing everything user-space, we use a simple trick.

The following block is added at the end of your `.bashrc` and/or `.zshrc` if it doesn't exists already:

```bash
# AUTO_FISH
# Start Fish only for interactive sessions
if [[ $- == *i* ]] && [ -x "$(command -v fish)" ]; then
  exec fish
fi
```

Conveniently, the `exec` command *replaces* the shell process with `fish`. I.e. `pstree` won't show `bash->fish`, just `fish`. Also, should you screw up your dotfiles install, your default shell stays whatever the OS provides.

## Notes on dealing with a failed install

TODO! `nix` atomic roolbacks are an amazing concept. Document how to roll back to a previous profile version...

```
