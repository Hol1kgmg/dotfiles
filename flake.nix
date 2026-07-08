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
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-k1low = {
      url = "github:k1LoW/homebrew-tap";
      flake = false;
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
      secretPath = builtins.getEnv "PWD" + "/local/secrets.nix";
      secrets =
        if builtins.getEnv "PWD" != "" && builtins.pathExists secretPath then
          import secretPath
        else
          {
            gitUsername = "";
            gitEmail = "";
            gitSigningkey = "";
          };
      # sudo実行時はUSER=rootになるためSUDO_USERを優先（--impureが必要）
      username =
        let
          sudoUser = builtins.getEnv "SUDO_USER";
          envUser = builtins.getEnv "USER";
        in
        if sudoUser != "" then sudoUser else envUser;
      system = "aarch64-darwin";
      hostname = "default";
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
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ inputs.nix-vscode-extensions.overlays.default ];
          };
          extraSpecialArgs = { inherit inputs secrets username; };
          modules = [
            ./home
            ./local/home
          ];
        };
        darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit inputs secrets username; };
          modules = [
            ./nix-darwin
            ./local/nix-darwin
          ];
        };
      };
    };
}
