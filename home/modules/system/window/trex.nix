{lib, ...}: {
  home.activation.trexSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Applying TRex settings..."

    # ヘルパー関数を読み込み
    source ${./lib/app-control.sh}

    # インストール確認
    if ! check_app_installed "/Applications/TRex.app"; then
      echo "TRex is not installed yet. Skipping settings..."
      exit 0
    fi

    # 起動中なら終了
    if ! stop_app_if_running "TRex" "TRex.app/Contents/MacOS/TRex$"; then
      exit 0
    fi

    TREX_PREFS="$HOME/Library/Group Containers/X93LWC49WV.TRex.preferences/Library/Preferences/X93LWC49WV.TRex.preferences"

    # 基本設定
    $DRY_RUN_CMD /usr/bin/defaults write "$TREX_PREFS" AutomaticLanguageDetection -bool true || true
    $DRY_RUN_CMD /usr/bin/defaults write "$TREX_PREFS" CaptureSound -bool false || true
    $DRY_RUN_CMD /usr/bin/defaults write "$TREX_PREFS" MenuBarIcon -string "Option2" || true
    $DRY_RUN_CMD /usr/bin/defaults write "$TREX_PREFS" NeedsOnboarding -bool false || true
    $DRY_RUN_CMD /usr/bin/defaults write "$TREX_PREFS" RecongitionLanguage -string "ja_JP" || true

    # 元々起動していた場合は再起動
    restart_app_if_was_running "TRex"
  '';
}
