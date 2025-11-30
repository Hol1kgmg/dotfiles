{ pkgs, ... }:

{
  imports = [
    ./zsh
  ];

  # シェル関連のCLIツール
  home.packages = with pkgs; [
    tree
  ];
}