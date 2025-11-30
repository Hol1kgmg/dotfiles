{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python package manager
    uv
  ];
}
