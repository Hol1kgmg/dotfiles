{ ... }:
{
  system = {
    stateVersion = 6;
    primaryUser = "mypc";
  };

  # sudoなし運用への移行に伴い home/default.nix (home-manager の nix.settings) へ移管。
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
    # sudoなし運用への移行に伴い home-manager (home/modules/system/) へ設定を移管。
    # ファイルは参照用に残しつつ、ここでのimportを無効化する。
    # ./keyboard.nix
    # ./dock.nix
    # ./finder.nix
    # ./trackpad.nix
    ./custom.nix
  ];
}
