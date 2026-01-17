{ pkgs, ... }:

{
  # nodejs
  home.packages = with pkgs; [
    nodejs_24
  ];
}
