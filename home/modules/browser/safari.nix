{lib, ...}: {
  # Safari設定をhome.activationで適用
  # nix-darwinはsudo実行必須のため、ユーザーレベルの設定はhome-managerで管理

  home.activation.safariSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Safari設定を適用
    echo "Applying Safari settings..."

    # Safariが開いている場合はスキップ
    SAFARI_RUNNING=$(/bin/ps aux | /usr/bin/grep -v grep | /usr/bin/grep -c "Safari.app/Contents/MacOS/Safari$" || echo "0")
    if [ "$SAFARI_RUNNING" -gt 0 ]; then
      echo -e "\033[1;33mWARNING: Safari起動中のため設定をスキップしました\033[0m"
    else
      # タブのレイアウトをコンパクトにする（macOS Sequoia 15.xまで有効）
      $DRY_RUN_CMD /usr/bin/defaults write com.apple.Safari EnableNarrowTabs -bool true || true

      # キーボードショートカット（日本語環境専用）
      # サイドバーの表示/非表示を Cmd+S に割り当て
      $DRY_RUN_CMD /usr/bin/defaults write com.apple.Safari NSUserKeyEquivalents -dict \
        "サイドバーを表示" "@s" \
        "サイドバーを非表示" "@s" || true
    fi
  '';
}
