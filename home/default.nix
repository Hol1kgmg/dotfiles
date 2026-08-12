{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # 元 nix-darwin nix.settings（sudoなし運用への移行、~/.config/nix/nix.conf に反映）
  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
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
