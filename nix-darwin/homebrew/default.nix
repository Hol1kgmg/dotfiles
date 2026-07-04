{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      extraFlags = [ "--force" ];
    };
    # taps は nix-homebrew で flake input として管理（./taps.nix）
  };

  imports = [
    ./taps.nix
    ./cask
    ./brew
  ];
}
