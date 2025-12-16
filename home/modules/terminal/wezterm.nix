{ config, pkgs, ... }:

{
  # WezTermパッケージをインストール（設定ファイル自動生成を回避）
  home.packages = [ pkgs.wezterm ];

  # 設定ファイルを配置
  xdg.configFile."wezterm".source = ./configs/wezterm;
}