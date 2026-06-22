{
  system = {
    stateVersion = 6;
    primaryUser = "mypc";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # シェル管理を無効化（home-manager で管理）
  programs.bash.enable = false;
  programs.zsh.enable = false;

  imports = [
    ./security.nix
    ./keyboard.nix
    ./dock.nix
    ./finder.nix
    ./trackpad.nix
    ./custom.nix
  ];
}
