{ pkgs, ... }:

{
  imports = [
    ./zsh
    ./oh-my-posh.nix
    ./fzf.nix
  ];

  # シェル関連のCLIツール
  home.packages = with pkgs; [
    tree
    btop
  ];

  xdg.configFile."btop/btop.conf".source = ./configs/btop/btop.conf;
}