{ pkgs, ... }:

{
  # Python package manager
  home.packages = [ pkgs.uv ];
}
