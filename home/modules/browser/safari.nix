{lib, ...}: {
  # Safari設定をhome.activationで適用
  # nix-darwinはsudo実行必須のため、ユーザーレベルの設定はhome-managerで管理

  home.activation.safariSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Safari設定を適用
    echo "Applying Safari settings..."

    # タブのレイアウトをコンパクトにする（macOS Sequoia 15.xまで有効）
    $DRY_RUN_CMD /usr/bin/defaults write com.apple.Safari EnableNarrowTabs -bool true

    # キーボードショートカット（日本語環境専用）
    # サイドバーの表示/非表示を Cmd+S に割り当て
    $DRY_RUN_CMD /usr/bin/defaults write com.apple.Safari NSUserKeyEquivalents -dict \
      "サイドバーを表示" "@s" \
      "サイドバーを非表示" "@s"
  '';
}
