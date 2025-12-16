{ config, pkgs, lib, ... }:

{
  # dockutilパッケージをインストール
  home.packages = [ pkgs.dockutil ];

  # Dockの設定を適用
  home.activation.configureDock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # dockutilのパス
    DOCKUTIL="${pkgs.dockutil}/bin/dockutil"

    # Dockから全てのアプリを削除（再起動なし）
    $DOCKUTIL --remove all --no-restart 2>/dev/null || true

    # 指定したアプリをDockに追加
    $DOCKUTIL --add "/System/Applications/Apps.app" --no-restart
    $DOCKUTIL --add "/Applications/Safari.app" --no-restart
    $DOCKUTIL --add "/System/Applications/System Settings.app" --no-restart
    $DOCKUTIL --add "/Applications/Visual Studio Code.app" --no-restart
    $DOCKUTIL --add "/Applications/WezTerm.app" --no-restart

    # Dockを再起動して変更を適用
    /usr/bin/killall Dock
  '';
}
