{lib, ...}: {
# windowマネージャー Rectangle設定
# help: キーバインド
# Left Half   : ctrl + h
# Right Half  : ctrl + l
# Max Size    : ctrl + a
# Next Display: ctrl + u


  home.activation.rectangleSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Applying Rectangle settings..."

    # ヘルパー関数を読み込み
    source ${./lib/app-control.sh}

    # インストール確認
    if ! check_app_installed "/Applications/Rectangle.app"; then
      echo "Rectangle is not installed yet. Skipping settings..."
      exit 0
    fi

    # 起動中なら終了
    if ! stop_app_if_running "Rectangle" "Rectangle.app/Contents/MacOS/Rectangle$"; then
      exit 0
    fi

    # 基本設定
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle allowAnyShortcut -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle launchOnLogin -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks -int 1 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle todo -int 2 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle todoMode -int 0 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle unsnapRestore -int 2 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle windowSnapping -int 2 || true

    # ショートカット設定（設定済み）
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle maximize -dict keyCode -float 0 modifierFlags -float 262144 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle nextDisplay -dict keyCode -float 32 modifierFlags -float 262144 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle restore -dict keyCode -float 51 modifierFlags -float 262144 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle rightHalf -dict keyCode -float 37 modifierFlags -float 262144 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle leftHalf -dict keyCode -float 4 modifierFlags -float 262144 || true
    
    # ショートカット設定（空）
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle almostMaximize -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle bottomHalf -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle bottomLeft -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle bottomRight -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle center -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle larger -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle maximizeHeight -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle previousDisplay -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle smaller -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle topHalf -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle topLeft -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle topRight -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle toggleTodo -dict || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle reflowTodo -dict || true

    # 元々起動していた場合は再起動
    restart_app_if_was_running "Rectangle"
  '';
}
