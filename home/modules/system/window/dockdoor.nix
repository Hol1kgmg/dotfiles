{lib, ...}: {
# Dockホバープレビュー DockDoor設定

  home.activation.dockdoorSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Applying DockDoor settings..."

    # ヘルパー関数を読み込み
    source ${./lib/app-control.sh}

    # インストール確認
    if ! check_app_installed "/Applications/DockDoor.app"; then
      echo "DockDoor is not installed yet. Skipping settings..."
      exit 0
    fi

    # 起動中なら終了
    if ! stop_app_if_running "DockDoor" "DockDoor.app/Contents/MacOS/DockDoor$"; then
      exit 0
    fi

    # カスタマイズ設定（Dockプレビュー本体はオフにし、スイッチャーとCmd+Tab拡張を使う構成）
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor SUEnableAutomaticChecks  -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor SUHasLaunchedBefore -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor SUSendProfileInfo -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor enableDockPreviews -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowsFromCurrentSpaceOnlyInSwitcher -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowsFromCurrentMonitorOnlyInSwitcher -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowlessAppsInSwitcher -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor enableCmdTabEnhancements -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor showWindowsFromCurrentSpaceOnlyInCmdTab -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor cmdTabEnabledTrafficLightButtons -array || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor cmdTabTrafficLightButtonsVisibility -string never || true

    # ウィンドウスイッチャー: 信号機ボタンを表示しない
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor switcherEnabledTrafficLightButtons -array || true
    $DRY_RUN_CMD /usr/bin/defaults write com.ethanbills.DockDoor switcherTrafficLightButtonsVisibility -string never || true

    # 元々起動していた場合は再起動
    restart_app_if_was_running "DockDoor"
  '';
}

/*
SUEnableAutomaticChecks = 0;
SUHasLaunchedBefore = 1;
SUSendProfileInfo = 0;
includeHiddenWindowsInCmdTab = 0;
ignoreAppsWithSingleWindowInCmdTab = 1;
enableCmdTabEnhancements = 0;
*/
/*
defaults read com.ethanbills.DockDoor.plist
（各行の # 以降はキー名から推測した設定内容のメモ。【内部状態】はアプリが自動更新する値で管理対象外）
{
    SUEnableAutomaticChecks = 0;                  # Sparkle: 自動アップデート確認（0=無効）
    SUHasLaunchedBefore = 1;                      # 【内部状態】Sparkle: 初回起動済みフラグ
    SUSendProfileInfo = 0;                        # Sparkle: プロファイル情報の送信（0=無効）
    bufferFromDock = "-20";                       # Dockとプレビューウィンドウの間隔（オフセット）
    cmdTabAppNameStyle = default;                 # Cmd+Tab: アプリ名の表示スタイル
    cmdTabAutoSelectFirstWindow = 0;              # Cmd+Tab: 最初のウィンドウを自動選択（0=無効）
    cmdTabControlPosition = topLeading;           # Cmd+Tab: コントロール（ボタン類）の表示位置＝左上
    cmdTabDisableDockStyleTitles = 0;             # Cmd+Tab: Dock風タイトル表示の無効化（0=有効のまま）
    cmdTabEnabledTrafficLightButtons =     (      # Cmd+Tab: プレビューに表示する信号機ボタン（空=なし）
    );
    cmdTabShowAppIconOnly = 0;                    # Cmd+Tab: アプリアイコンのみ表示（0=無効）
    cmdTabShowAppName = 1;                        # Cmd+Tab: アプリ名を表示（1=有効）
    cmdTabShowWindowTitle = 1;                    # Cmd+Tab: ウィンドウタイトルを表示（1=有効）
    cmdTabTrafficLightButtonsVisibility = never;  # Cmd+Tab: 信号機ボタンの表示タイミング＝常に非表示
    cmdTabWindowTitleVisibility = whenHoveringPreview; # Cmd+Tab: ウィンドウタイトルの表示タイミング＝プレビューをホバー中のみ
    disableImagePreview = 0;                      # ウィンドウ画像プレビューの無効化（0=プレビュー表示する）
    enableCmdRightClickQuit = 0;                  # ★カスタム（デフォルト: 1） Cmd+右クリックでアプリ終了（0=無効）
    enableCmdTabEnhancements = 1;                 # Cmd+Tab 拡張機能（DockDoor製スイッチャー）を有効化
    enableDockLocking = 0;                        # Dockを特定ディスプレイに固定する機能（0=無効）
    enableDockPreviews = 0;                       # Dockアイコンホバー時のプレビュー（0=無効 ※本体機能がオフな点に注意）
    enableMouseHoverInSwitcher = 1;               # スイッチャー内でマウスホバー選択を有効化
    enableShiftWindowSwitcherPlacement = 0;       # スイッチャー表示位置のシフト（0=無効）
    enableWindowSwitcher = 1;                     # ウィンドウスイッチャー機能を有効化
    enableWindowSwitcherSearch = 0;               # スイッチャー内の検索機能（0=無効）
    groupAppInstancesInDock = 0;                  # ★カスタム（デフォルト: 1） Dockでアプリの複数インスタンスをまとめる（0=無効）
    hasSeenCmdTabFocusHint = 1;                   # 【内部状態】Cmd+Tabのヒント表示済みフラグ
    ignoreAppsWithSingleWindow = 0;               # Dockプレビュー: ウィンドウが1つだけのアプリを無視（0=無効）
    ignoreAppsWithSingleWindowInCmdTab = 1;       # ★カスタム（デフォルト: 0） Cmd+Tab: ウィンドウが1つだけのアプリはウィンドウ単位に展開しない（1=有効）
    includeHiddenWindowsInCmdTab = 0;             # ★カスタム（デフォルト: 1） Cmd+Tab: 非表示ウィンドウを含める（0=含めない）
    includeHiddenWindowsInDockPreview = 0;        # ★カスタム（デフォルト: 1） Dockプレビュー: 非表示ウィンドウを含める（0=含めない）
    includeHiddenWindowsInSwitcher = 0;           # ★カスタム（デフォルト: 1） スイッチャー: 非表示ウィンドウを含める（0=含めない）
    lastKnownScreenRecordingPermission = 0;       # 【内部状態】画面収録権限の最終確認結果
    launched = 1;                                 # 【内部状態】起動済みフラグ
    limitSwitcherToFrontmostApp = 0;              # スイッチャーを最前面アプリのウィンドウに限定（0=無効）
    # ↓ lockedDockScreenIdentifier: 【内部状態】Dock固定機能用のディスプレイ識別子
    lockedDockScreenIdentifier = "Optional(1)-1440.0-900.0-Optional(8)-Optional(\\"NSCalibratedRGBColorSpace\\")";
    mouseFollowsFocusMode = never;                # フォーカスにマウスカーソルを追従させるモード＝しない
    # ↓ persistedWindowOrder: 【内部状態】ウィンドウ順序のキャッシュ（管理対象外）
    persistedWindowOrder =     (
        "{\\"bundleIdentifier\\":\\"org.mozilla.firefox\\",\\"creationTime\\":804868502.183657,\\"lastAccessedTime\\":804869415.581123,\\"windowTitle\\":\\"DockDoor Docs - AppleScript & Automation Guide\\"}",
        "{\\"bundleIdentifier\\":\\"com.github.wez.wezterm\\",\\"creationTime\\":804865759.656647,\\"lastAccessedTime\\":804869395.621699,\\"windowTitle\\":\\"dotfiles\\"}",
        "{\\"bundleIdentifier\\":\\"com.ethanbills.DockDoor\\",\\"creationTime\\":804865840.376672,\\"lastAccessedTime\\":804869274.593364,\\"windowTitle\\":\\"\\"}",
        "{\\"bundleIdentifier\\":\\"com.apple.systempreferences\\",\\"creationTime\\":804865774.734385,\\"lastAccessedTime\\":804869207.794518,\\"windowTitle\\":\\"\\U753b\\U9762\\U53ce\\U9332\\U3068\\U30b7\\U30b9\\U30c6\\U30e0\\U30aa\\U30fc\\U30c7\\U30a3\\U30aa\\U9332\\U97f3\\"}"
    );
    reopenSettingsAfterRestart = 0;               # 再起動後に設定画面を再度開く（0=無効）
    showWindowlessAppsInCmdTab = 0;               # Cmd+Tab: ウィンドウを持たないアプリも表示（0=無効）
    showWindowlessAppsInSwitcher = 0;             # ★カスタム（デフォルト: 1） スイッチャー: ウィンドウを持たないアプリも表示（0=無効）
    showWindowsFromCurrentMonitorOnly = 0;        # Dockプレビュー: 現在のモニターのウィンドウのみ表示（0=全モニター）
    showWindowsFromCurrentMonitorOnlyInCmdTab = 0;    # Cmd+Tab: 現在のモニターのみ（0=全モニター）
    showWindowsFromCurrentMonitorOnlyInSwitcher = 1;  # スイッチャー: 現在のモニターのみ（1=有効）
    showWindowsFromCurrentSpaceOnly = 0;          # Dockプレビュー: 現在のSpaceのウィンドウのみ表示（0=全Space）
    showWindowsFromCurrentSpaceOnlyInCmdTab = 0;  # Cmd+Tab: 現在のSpaceのみ（0=全Space）
    showWindowsFromCurrentSpaceOnlyInSwitcher = 1;    # スイッチャー: 現在のSpaceのみ（1=有効）
    sortMinimizedToEnd = 1;                       # 最小化中のウィンドウを一覧の末尾に並べる（1=有効）
    switcherAppIconSize = 0;                      # スイッチャー: アプリアイコンのサイズ（0=デフォルト）
    switcherEnabledTrafficLightButtons =     (    # スイッチャー: 表示する信号機ボタン（空=なし）
    );
    switcherIgnoreScreenLimit = 0;                # スイッチャー: 画面サイズ制限を無視（0=無効）
    switcherShowAppHeader = 1;                    # スイッチャー: アプリ名ヘッダーを表示（1=有効）
    switcherShowWindowTitle = 0;                  # スイッチャー: ウィンドウタイトルを表示（0=無効）
    switcherTrafficLightButtonsVisibility = never;    # スイッチャー: 信号機ボタンの表示タイミング＝常に非表示
    windowSwitcherControlPosition = topLeading;   # スイッチャー: コントロールの表示位置＝左上
    windowSwitcherPlacementStrategy = screenWithMouse; # スイッチャー: 表示先＝マウスカーソルのある画面
    windowSwitcherScrollDirection = vertical;     # スイッチャー: スクロール方向＝縦
}
*/

/*
アプリのデフォルト設定
defaults read com.ethanbills.DockDoor.plist
{
    SUHasLaunchedBefore = 1;
    UserKeybind = "{\\"keyCode\\":48,\\"modifierFlags\\":524576}";
    alternateKeybindKey = 0;
    alternateKeybindMode = activeAppOnly;
    bufferFromDock = "-20";
    cmdShortcut1Action = close;
    cmdShortcut1Key = 13;
    cmdShortcut2Action = minimize;
    cmdShortcut2Key = 46;
    cmdShortcut3Action = quit;
    cmdShortcut3Key = 12;
    cmdTabAutoSelectFirstWindow = 0;
    cmdTabCycleKey = 0;
    disableImagePreview = 0;
    dockClickAction = hide;
    dockLockOverrideModifier = 0;
    dockSwipeAwayFromDockAction = maximize;
    dockSwipeTowardsDockAction = minimize;
    enableCmdRightClickQuit = 1;
    enableDockItemWidgets = 1;
    enableDockLocking = 0;
    enableDockPreviewGestures = 1;
    enableFolderWidget = 1;
    enablePinning = 1;
    enableShiftWindowSwitcherPlacement = 0;
    enableWindowSwitcher = 1;
    fadeOutDuration = "0.4";
    filteredCalendarIdentifiers =     (
    );
    folderWidgetDefaultSortOrder = dateModified;
    folderWidgetDefaultSortReversed = 1;
    folderWidgetRememberSortPerFolder = 1;
    folderWidgetShowHiddenFiles = 0;
    folderWidgetSortOrders =     {
    };
    folderWidgetSortReversed =     {
    };
    fullscreenAppBlacklist =     (
    );
    gestureSwipeThreshold = 50;
    groupAppInstancesInDock = 1;
    ignoreAppsWithSingleWindowInCmdTab = 0;
    includeHiddenWindowsInCmdTab = 1;
    includeHiddenWindowsInDockPreview = 1;
    includeHiddenWindowsInSwitcher = 1;
    instantWindowSwitcher = 0;
    lastKnownScreenRecordingPermission = 0;
    launched = 1;
    limitSwitcherToFrontmostApp = 0;
    lockedDockScreenIdentifier = "";
    middleClickAction = close;
    openDelay = "0.2";
    openNewWindowForWindowlessApps = 0;
    persistedWindowOrder =     (
        "{\\"bundleIdentifier\\":\\"com.ethanbills.DockDoor\\",\\"creationTime\\":804865840.376672,\\"lastAccessedTime\\":804870077.477291,\\"windowTitle\\":\\"\\"}",
        "{\\"bundleIdentifier\\":\\"com.apple.systempreferences\\",\\"creationTime\\":804865774.734385,\\"lastAccessedTime\\":804870072.617751,\\"windowTitle\\":\\"\\U753b\\U9762\\U53ce\\U9332\\U3068\\U30b7\\U30b9\\U30c6\\U30e0\\U30aa\\U30fc\\U30c7\\U30a3\\U30aa\\U9332\\U97f3\\"}",
        "{\\"bundleIdentifier\\":\\"com.github.wez.wezterm\\",\\"creationTime\\":804865759.656647,\\"lastAccessedTime\\":804869786.600441,\\"windowTitle\\":\\"dotfiles\\"}",
        "{\\"bundleIdentifier\\":\\"org.mozilla.firefox\\",\\"creationTime\\":804869426.947363,\\"lastAccessedTime\\":804869782.619779,\\"windowTitle\\":\\"DockDoor\\U306e\\U30a6\\U30a3\\U30f3\\U30c9\\U30a6\\U30b9\\U30a4\\U30c3\\U30c1\\U30e3\\U30fc\\U8a2d\\U5b9a - Claude\\"}"
    );
    pinnedScreenIdentifier = "";
    preventDockHide = 0;
    previewHoverAction = none;
    reopenSettingsAfterRestart = 0;
    requireShiftTabToGoBack = 0;
    restoreAllMinimizedWindowsOnDockClick = 1;
    screenCaptureCacheLifespan = 30;
    searchTriggerKey = 44;
    shouldHideOnDockItemClick = 0;
    showBigControlsWhenNoValidWindows = 1;
    showMassActionButtons = 1;
    showMenuBarIcon = 1;
    showSpecialAppControls = 1;
    showWindowlessAppsInCmdTab = 0;
    showWindowlessAppsInDockPreview = 0;
    showWindowlessAppsInSwitcher = 1;
    tapEquivalentInterval = "1.5";
    useClassicWindowOrdering = 1;
    useEmbeddedMediaControls = 1;
    windowPreviewImageScale = 1;
    windowSwitcherAnchorToTop = 0;
    windowSwitcherHorizontalOffsetPercent = 0;
    windowSwitcherPlacementStrategy = screenWithMouse;
    windowSwitcherVerticalOffsetPercent = 0;
}
*/

/*
== カスタマイズ差分まとめ（現在の設定 vs デフォルト設定） ==

★ 値がデフォルトと異なる（確実なカスタマイズ・7項目）
  キー                                現在      デフォルト
  enableCmdRightClickQuit             0         1   # Cmd+右クリック終了を無効化
  groupAppInstancesInDock             0         1   # Dockでの複数インスタンスまとめを無効化
  ignoreAppsWithSingleWindowInCmdTab  1         0   # Cmd+Tabで単一ウィンドウアプリを展開しない
  includeHiddenWindowsInCmdTab        0         1   # Cmd+Tabに非表示ウィンドウを含めない
  includeHiddenWindowsInDockPreview   0         1   # Dockプレビューに非表示ウィンドウを含めない
  includeHiddenWindowsInSwitcher      0         1   # スイッチャーに非表示ウィンドウを含めない
  showWindowlessAppsInSwitcher        0         1   # スイッチャーにウィンドウなしアプリを表示しない

△ 現在の設定にのみ存在するキー（過去にGUIで触った可能性が高い。デフォルト値はメモからは不明）
  - Cmd+Tab 表示系: cmdTabAppNameStyle, cmdTabControlPosition, cmdTabDisableDockStyleTitles,
    cmdTabEnabledTrafficLightButtons, cmdTabShowAppIconOnly, cmdTabShowAppName,
    cmdTabShowWindowTitle, cmdTabTrafficLightButtonsVisibility, cmdTabWindowTitleVisibility
  - 機能ON/OFF: enableCmdTabEnhancements=1, enableDockPreviews=0（本体機能オフ）,
    enableMouseHoverInSwitcher=1, enableWindowSwitcherSearch=0
  - 表示範囲: showWindowsFromCurrentMonitorOnly*（スイッチャーのみ1）,
    showWindowsFromCurrentSpaceOnly*（スイッチャーのみ1）, ignoreAppsWithSingleWindow=0
  - スイッチャー表示系: sortMinimizedToEnd=1, switcherAppIconSize=0,
    switcherEnabledTrafficLightButtons=(), switcherIgnoreScreenLimit=0,
    switcherShowAppHeader=1, switcherShowWindowTitle=0,
    switcherTrafficLightButtonsVisibility=never, windowSwitcherControlPosition=topLeading,
    windowSwitcherScrollDirection=vertical
  - その他: SUEnableAutomaticChecks=0, SUSendProfileInfo=0, mouseFollowsFocusMode=never

○ デフォルト設定にのみ存在するキー（未変更＝デフォルトのまま。キーバインド・ジェスチャー・
  ウィジェット・フォルダ関連など約40項目）→ Nix管理は不要

※ 値が同じキー: bufferFromDock, cmdTabAutoSelectFirstWindow, disableImagePreview,
  enableDockLocking, enableShiftWindowSwitcherPlacement, enableWindowSwitcher,
  limitSwitcherToFrontmostApp, reopenSettingsAfterRestart, showWindowlessAppsInCmdTab,
  windowSwitcherPlacementStrategy
*/
