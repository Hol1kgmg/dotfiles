{
  description = "Hol1kgmg's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      inherit (import ./home/options.nix) username;
      system = builtins.currentSystem;
      hostname = "mac-book-pro";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.writeShellScriptBin "formatter" ''
            # 引数がない場合は全ての.nixファイルをフォーマット
            if [ $# -eq 0 ]; then
              ${pkgs.nixfmt-rfc-style}/bin/nixfmt **/*.nix
            else
              ${pkgs.nixfmt-rfc-style}/bin/nixfmt "$@"
            fi
          '';

          apps.default = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "update-script" ''
                set -e
                echo "Updating flake..."
                nix flake update
                echo "Updating home-manager..."
                nix run nixpkgs#home-manager -- switch --flake .#${username} --impure
                echo "Update complete!"
              ''
            );
          };
        };

      flake = {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home ];
        };
        darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [ ./nix-darwin ];
        };
      };
    };
}
