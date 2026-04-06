{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };
    taps = [
      # "dimentium/autoraise"
      "wezterm/wezterm"
    ];
  };

  imports = [
    ./cask
    ./brew
  ];
}
