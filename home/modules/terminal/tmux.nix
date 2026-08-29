{ config, pkgs, ... }:

{
  home.packages = [ pkgs.tmux ];

  xdg.configFile."tmux/tmux.conf".source = ./configs/tmux/tmux.conf;
}
