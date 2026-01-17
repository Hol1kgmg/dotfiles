{ pkgs, ... }:

{
  # nodejs packages manager
  home.packages = with pkgs; [
    pnpm
  ];
}
