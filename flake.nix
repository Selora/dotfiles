{
  description = "Install basic sla-shell environement";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable }: let
    # Define package lists
    stablePackages = [
      # Utilities for standard gnu tools aliases
      "eza"                 # ls replacement
      "bat"                 # cat replacement
      "ripgrep"             # grep replacement
      "fd"                  # find replacement
      "starship"            # Gives a nice prompt header
      "zoxide"              # cd replacement
      "fzf"                 # Fuzzy-finder used in many tools
      "fish"                # The best shell
      "stow"                # dotfile manager
      # "chafa"       # image viewer for nvim, fzf-lua
      # "viu"       # image viewer for nvim, fzf-lua
      
      # Dev Env & Languages
      # Some are dependencies for neovim plugins.... 
      # ex: pyright needs node & npm...
      # Makes a good dependency mess, but it's contained to this nix-profiles
      "direnv"      # setup env vars upon entering a directory
      "lua5_1"
      "luarocks-nix"
      "lazygit"
      "tree-sitter"
      "nodejs"
      "nil"
      "cargo"
      "tmux"
      "just"
      "uv"
      "python313"
    ];
    unstablePackages = [
      "neovim"
    ];

systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

        # Function to create a derivation that combines stable & unstable packages
    mkPackages = system: let
      pkgsStable = import nixpkgs-stable { inherit system; };
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
      lib = pkgsStable.lib; # Access standard library
    in pkgsStable.buildEnv {
      name = "my-tools";
      paths = lib.concatLists [
        (builtins.map (pkg: pkgsStable.${pkg}) stablePackages)
        (builtins.map (pkg: pkgsUnstable.${pkg}) unstablePackages)
      ];
    };

  in {
    # Generate derivations for all supported architectures
    packages = builtins.listToAttrs (map (system: {
      name = system;
      value = mkPackages system; # Directly a derivation for nix build
    }) systems);

    # Set a global default package for `nix build .`
    defaultPackage = self.packages.x86_64-linux;

    #invoke with:
    # nix build .#packages.x86_64-linux
    # nix profile install .#packages.x86_64-linux
  };
}
