{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # GitHub CLI
    gh

    # Python package manager
    uv
  ];
}
