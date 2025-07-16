{
  description = "Install daily driver extra sla-shell environement";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable }:
    let
      # Define package lists
      stablePackages = [

      ];
      unstablePackages = [ "taskwarrior3" "timewarrior" ];

      systems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # Function to create a derivation that combines stable & unstable packages
      mkPackages = system:
        let
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
      packages_main_host = builtins.listToAttrs (map (system: {
        name = system;
        value = mkPackages system; # Directly a derivation for nix build
      }) systems);

      # Set a global default package for `nix build .`
      defaultPackage = self.packages_main_host.x86_64-linux;

      #invoke with:
      # nix build .#packages.x86_64-linux
      # nix profile install .#packages.x86_64-linux
    };
}
