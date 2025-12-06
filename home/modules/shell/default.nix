{ pkgs, ... }:

{
  imports = [
    ./zsh
    ./oh-my-posh.nix
  ];

  # シェル関連のCLIツール
  home.packages = with pkgs; [
    tree
  ];
}