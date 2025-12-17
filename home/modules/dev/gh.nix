{ pkgs, ... }:

{
  # GitHub CLI
  home.packages = [ pkgs.gh ];
}
