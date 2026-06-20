{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
      extraFlags = [ "--force" ];
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
