{ config, pkgs, ... }:

{
  # mise設定
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
