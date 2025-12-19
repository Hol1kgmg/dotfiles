{ config, pkgs, ... }:

{
  # フォント管理
  # fonts.fontconfig.enable = false;
  
  home.packages = [
  pkgs.plemoljp-nf
  ];
  # home.packages = with pkgs; [
  #   # Nerd Fonts（oh my posh用）
  #   nerd-fonts.jetbrains-mono
  #   # Nerd Fonts（日本語対応）
  #   # nerd-fonts.m+
  # ];
}
