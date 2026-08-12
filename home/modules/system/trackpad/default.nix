{ lib, ... }:

{
  # 元 nix-darwin system.defaults.trackpad / NSGlobalDomain（sudoなし運用への移行）
  home.activation.configureTrackpad = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # トラックパッド感度(0.0-3.0が標準範囲、4.0は高速)
    /usr/bin/defaults write -g com.apple.trackpad.scaling -float 4.0
  '';
}
