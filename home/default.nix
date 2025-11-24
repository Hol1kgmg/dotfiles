{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (import ./options.nix) username;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };

  imports = [
    ./modules
  ];

  programs.home-manager.enable = true;
}
