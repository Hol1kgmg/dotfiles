{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      extraFlags = [ "--force" ];
    };
  };

  imports = [
    ./taps.nix
    ./cask
    ./brew
  ];
}
