{lib, ...}: {
  # Rectangle設定をhome.activationで適用
  # nix-darwinはsudo実行必須のため、ユーザーレベルの設定はhome-managerで管理

  home.activation.rectangleSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Rectangle設定を適用
    echo "Applying Rectangle settings..."

    # Rectangleがインストールされているか確認
    if [ ! -d "/Applications/Rectangle.app" ]; then
      echo "Rectangle is not installed yet. Skipping settings..."
      exit 0
    fi

    # Rectangleが開いている場合は終了させる
    RECTANGLE_RUNNING=$(/bin/ps aux | /usr/bin/grep -v grep | /usr/bin/grep -c "Rectangle.app/Contents/MacOS/Rectangle$" 2>/dev/null || echo "0")
    RECTANGLE_RUNNING=$(echo "$RECTANGLE_RUNNING" | /usr/bin/tr -d '\n')

    # 元々起動していたかどうかを記録
    RECTANGLE_WAS_RUNNING="$RECTANGLE_RUNNING"

    if [ "$RECTANGLE_RUNNING" -gt 0 ] 2>/dev/null; then
      echo "Rectangle起動中のため終了します..."
      /usr/bin/osascript -e 'quit app "Rectangle"' || true

      # 終了を確認（最大10秒待機）
      COUNTER=0
      while [ $COUNTER -lt 10 ]; do
        STILL_RUNNING=$(/bin/ps aux | /usr/bin/grep -v grep | /usr/bin/grep -c "Rectangle.app/Contents/MacOS/Rectangle$" 2>/dev/null || echo "0")
        STILL_RUNNING=$(echo "$STILL_RUNNING" | /usr/bin/tr -d '\n')

        if [ "$STILL_RUNNING" -eq 0 ] 2>/dev/null; then
          echo "Rectangleの終了を確認しました"
          break
        fi
        sleep 1
        COUNTER=$((COUNTER + 1))
      done

      # まだ起動している場合は警告して終了
      STILL_RUNNING=$(/bin/ps aux | /usr/bin/grep -v grep | /usr/bin/grep -c "Rectangle.app/Contents/MacOS/Rectangle$" 2>/dev/null || echo "0")
      STILL_RUNNING=$(echo "$STILL_RUNNING" | /usr/bin/tr -d '\n')

      if [ "$STILL_RUNNING" -gt 0 ] 2>/dev/null; then
        echo -e "\033[1;33mWARNING: Rectangleが終了しませんでした。設定をスキップします\033[0m"
        exit 0
      fi
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
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle rightHalf -dict keyCode -float 37 modifierFlags -float 786432 || true
    $DRY_RUN_CMD /usr/bin/defaults write com.knollsoft.Rectangle leftHalf -dict keyCode -float 4 modifierFlags -float 786432 || true
    
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
    if [ "$RECTANGLE_WAS_RUNNING" -gt 0 ] 2>/dev/null; then
      echo "Rectangleを再起動します..."
      /usr/bin/open -a Rectangle || true
    fi
  '';
}
