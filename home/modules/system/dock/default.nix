{ config, pkgs, lib, ... }:

{
  # dockutilパッケージをインストール
  home.packages = [ pkgs.dockutil ];

  # Dockの設定を適用
  home.activation.configureDock = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # 元nix-darwin system.defaults.dock（sudoなし運用への移行）
    # Dockを自動的に隠す/表示
    /usr/bin/defaults write com.apple.dock autohide -bool true
    # 最近使ったアプリケーションをDockに表示しない
    /usr/bin/defaults write com.apple.dock show-recents -bool false

    # dockutilのパス
    DOCKUTIL="${pkgs.dockutil}/bin/dockutil"

    # Dockから全てのアプリを削除（再起動なし）
    $DOCKUTIL --remove all --no-restart 2>/dev/null || true

    # 指定したアプリをDockに追加
    $DOCKUTIL --add "/System/Applications/Apps.app" --no-restart
    
    # ブラウザ
    $DOCKUTIL --add "/Applications/Safari.app" --no-restart
    $DOCKUTIL --add "/Applications/Google Chrome Canary.app" --no-restart

    # 開発ツール
    $DOCKUTIL --add "/Applications/Visual Studio Code.app" --no-restart
    $DOCKUTIL --add "/Applications/WezTerm.app" --no-restart
    $DOCKUTIL --add "/Applications/Docker.app/Contents/MacOS/Docker Desktop.app" --no-restart

    # ユーティリティ
    $DOCKUTIL --add "/System/Applications/Utilities/Activity Monitor.app" --no-restart
    $DOCKUTIL --add "/System/Applications/Preview.app" --no-restart
    $DOCKUTIL --add "/System/Applications/QuickTime Player.app" --no-restart

    # フォルダを追加
    $DOCKUTIL --add "${config.home.homeDirectory}/Downloads" --no-restart

    # Dockを再起動して変更を適用
    /usr/bin/killall Dock
  '';
}
