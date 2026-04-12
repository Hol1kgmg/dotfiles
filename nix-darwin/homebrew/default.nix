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
      # "wezterm/wezterm"
      # "manaflow-ai/cmux"
    ];
  };

  imports = [
    ./cask
    ./brew
  ];
}
