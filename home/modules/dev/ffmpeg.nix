{ pkgs, ... }:

{
  # video packages
  home.packages = with pkgs; [
    ffmpeg
  ];
}
