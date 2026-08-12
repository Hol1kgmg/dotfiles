{ ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = "mypc";
  };

  # home/default.nix の nix.settings で管理（README.md「設定管理の方針」参照）。
  # nix.settings = {
  #   experimental-features = [
  #     "nix-command"
  #     "flakes"
  #   ];
  # };

  # シェル管理を無効化（home-manager で管理）
  programs.bash.enable = false;
  programs.zsh.enable = false;

  imports = [
    ./security.nix
    # home-manager (home/modules/system/) で管理（README.md「設定管理の方針」参照）。
    # ./keyboard.nix
    # ./dock.nix
    # ./finder.nix
    # ./trackpad.nix
    ./custom.nix
  ];
}
