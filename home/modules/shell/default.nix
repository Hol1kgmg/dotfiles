{ pkgs, ... }:

{
  imports = [
    ./zsh
    ./oh-my-posh.nix
    # ./starship.nix

    ./fzf.nix
  ];

  # シェル関連のCLIツール
  home.packages = with pkgs; [
    tree
    btop
    witr # プロセスの実行理由を調べる
  ];

  xdg.configFile."btop/btop.conf".source = ./configs/btop/btop.conf;
  xdg.configFile."localhost-top/config.json".source = ./configs/localhost-top/config.json;
}
