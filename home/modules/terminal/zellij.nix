{ config, pkgs, ... }:

{
  # Zellij設定
  programs.zellij = {
    enable = true;
  };

  # 設定ファイルを配置
  xdg.configFile."zellij".source = ./configs/zellij;
}
