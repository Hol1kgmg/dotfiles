{ config, pkgs, ... }:

{
  # Oh My Posh設定
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    useTheme = "wholespace";
  };
}
