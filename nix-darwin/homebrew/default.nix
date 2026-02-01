{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    taps = [
      "dimentium/autoraise"
    ];
  };

  imports = [
    ./cask
    ./brew
  ];
}
