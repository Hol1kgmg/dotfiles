{ config, pkgs, ... }:

{
  # WezTerm設定
  programs.wezterm = {
    enable = true;
  };

  # 設定ファイルを配置
  xdg.configFile."wezterm".source = ./configs/wezterm;
}