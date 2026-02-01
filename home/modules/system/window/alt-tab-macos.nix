{lib, ...}: {
  # AltTab設定
  home.activation.altTabSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Applying AltTab settings..."

    # ヘルパー関数を読み込み
    source ${./lib/app-control.sh}

    # インストール確認
    if ! check_app_installed "/Applications/AltTab.app"; then
      echo "AltTab is not installed yet. Skipping settings..."
      exit 0
    fi

    # 起動中なら終了
    if ! stop_app_if_running "AltTab" "AltTab.app/Contents/MacOS/AltTab$"; then
      exit 0
    fi

    # 外観設定
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos appearanceSize -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos appearanceStyle -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos menubarIcon -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos menubarIconShown -bool true || true

    # コントロール設定
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos screensToShow -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos showHiddenWindows -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos showMinimizedWindows -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos showWindowlessApps -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos spacesToShow -int 1 || true

    # その他
    $DRY_RUN_CMD /usr/bin/defaults write com.lwouis.alt-tab-macos updatePolicy -int 1 || true

    # 元々起動していた場合は再起動
    restart_app_if_was_running "AltTab"
  '';
}
