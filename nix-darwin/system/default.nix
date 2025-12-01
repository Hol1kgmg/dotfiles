{
  system = {
    stateVersion = 6;
    primaryUser = "mypc";
  };

  # Determinate Nix を使用しているため、nix-darwin の Nix 管理を無効化
  nix.enable = false;

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
