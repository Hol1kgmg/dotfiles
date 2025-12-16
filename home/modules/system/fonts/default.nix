{ config, pkgs, ... }:

{
  # フォント管理
  home.packages = with pkgs; [
    # Nerd Fonts（oh my posh用）
    nerd-fonts.jetbrains-mono
  ];
}
