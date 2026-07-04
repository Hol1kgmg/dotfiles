{ config, inputs, username, ... }:

{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  # nix-homebrew 管理の tap を Brewfile にも反映し、
  # cleanup が untap を試みてエラーになるのを防ぐ
  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  # taps は flake input として固定管理（mutableTaps = false）
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = username;
    autoMigrate = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
    mutableTaps = false;
  };
}
