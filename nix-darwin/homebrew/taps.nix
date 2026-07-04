{ inputs, username, ... }:

{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

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
