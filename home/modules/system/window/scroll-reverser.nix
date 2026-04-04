{lib, ...}: {
  # スクロール反転ツール Scroll Reverser 設定
  # マウスのスクロールを反転し、トラックパッドは自然スクロールを維持

  home.activation.scrollReverserSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Applying Scroll Reverser settings..."

    # ヘルパー関数を読み込み
    source ${./lib/app-control.sh}

    # インストール確認
    if ! check_app_installed "/Applications/Scroll Reverser.app"; then
      echo "Scroll Reverser is not installed yet. Skipping settings..."
      exit 0
    fi

    # 起動中なら終了
    if ! stop_app_if_running "Scroll Reverser" "ScrollReverser.app/Contents/MacOS/Scroll Reverser$"; then
      exit 0
    fi

    # 基本設定
    $DRY_RUN_CMD /usr/bin/defaults write com.pilotmoon.scroll-reverser InvertScrollingOn -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.pilotmoon.scroll-reverser ReverseTrackpad -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.pilotmoon.scroll-reverser ShowDiscreteScrollOptions -int 1 || true

    # 元々起動していた場合は再起動
    restart_app_if_was_running "Scroll Reverser"
  '';
}
