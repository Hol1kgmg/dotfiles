{lib, ...}: {
# Dockホバープレビュー DockDoor設定

  home.activation.dockdoorSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Applying DockDoor settings..."

    source ${./lib/app-control.sh}

    if ! check_app_installed "/Applications/DockDoor.app"; then
      echo "DockDoor is not installed yet. Skipping settings..."
      exit 0
    fi

    if ! stop_app_if_running "DockDoor" "DockDoor.app/Contents/MacOS/DockDoor$"; then
      exit 0
    fi

    # Sparkle: 自動アップデート確認・プロファイル送信を無効化
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor SUEnableAutomaticChecks -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor SUHasLaunchedBefore -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor SUSendProfileInfo -int 0 || true

    # Dockプレビュー本体はオフ（スイッチャーとCmd+Tab拡張を使う構成）
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor enableDockPreviews -int 0 || true

    # スイッチャー: 現在のSpace・モニターのウィンドウのみ表示
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowsFromCurrentSpaceOnlyInSwitcher -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowsFromCurrentMonitorOnlyInSwitcher -int 1 || true
    # スイッチャー: ウィンドウなしアプリを非表示
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowlessAppsInSwitcher -int 0 || true
    # sスイッチャー: アクティブなアプリのウィンドウに限定しない
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor limitSwitcherToFrontmostApp -int 0 || true
    # スイッチャー: 非表示ウィンドウを含めない
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor includeHiddenWindowsInSwitcher -int 0 || true

    # スイッチャー: 信号機ボタンを非表示
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor switcherEnabledTrafficLightButtons -array || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor switcherTrafficLightButtonsVisibility -string never || true

    # Cmd+Tab: 拡張機能を無効化
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor enableCmdTabEnhancements -int 0 || true
    # Cmd+Tab: 現在のSpaceのウィンドウのみ表示
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowsFromCurrentSpaceOnlyInCmdTab -int 1 || true
    # Cmd+Tab: 信号機ボタンを非表示
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor cmdTabEnabledTrafficLightButtons -array || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor cmdTabTrafficLightButtonsVisibility -string never || true

    restart_app_if_was_running "DockDoor"
  '';
}
