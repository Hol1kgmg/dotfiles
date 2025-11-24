{
  description = "Hol1kgmg's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      packages.${system}.my-packages = pkgs.buildEnv {
        name = "my-packages-list";
        paths = with pkgs; [
          git
          curl
          nixfmt-rfc-style
          # ここにパッケージを追記していく
        ];
      };

      # nix flake updateコマンドのalias
      apps.${system}.update = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "update-script" ''
            set -e
            echo "Updating flake..."
            nix flake update
            echo "Updating profile..."
            nix profile upgrade my-packages
            echo "Update complete!"
          ''
        );
      };
    };
}
