{ config, pkgs, ... }:

{
  xdg.configFile."wezterm".source = ./configs/wezterm;
}
