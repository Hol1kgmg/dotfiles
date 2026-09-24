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

  # nix.gc は home-manager に存在しないため nix-darwin 側で管理（方針の例外）。
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };

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
