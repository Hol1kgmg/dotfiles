{ ... }:

{
  # ========================================
  # キーボード - 修飾キー設定
  # ========================================

  system.keyboard = {
    # キーボードマッピングを有効化
    enableKeyMapping = true;

    # Caps LockキーをControlキーにリマップ
    remapCapsLockToControl = true;
  };

  # ========================================
  # Fn/地球儀キーの設定
  # ========================================

  system.defaults.hitoolbox = {
    # Fn/地球儀キーを押したときの動作
    AppleFnUsageType = "Do Nothing";
    # 他の選択肢: "Change Input Source", "Show Emoji & Symbols", "Start Dictation"
  };

  # ========================================
  # テキスト入力設定
  # ========================================

  system.defaults.NSGlobalDomain = {
    # 文頭を自動的に大文字にする
    NSAutomaticCapitalizationEnabled = false;

    # スペースバーを2回押してピリオドを入力
    NSAutomaticPeriodSubstitutionEnabled = false;

    # 英字入力中にスペルを自動変換
    NSAutomaticSpellingCorrectionEnabled = false;

    # キー長押し時のアクセント文字表示を無効化
    ApplePressAndHoldEnabled = false;

    # キーリピート開始までの遅延（15=標準、10=最速推奨）
    InitialKeyRepeat = 15;

    # キーリピートの速度（2=標準、1=最速）
    KeyRepeat = 1;

    # インライン予測テキストを表示
    NSAutomaticInlinePredictionEnabled = false;
  };

  # ========================================
  # メニューバー設定
  # ========================================

  system.defaults.CustomUserPreferences = {
    # メニューバーに入力メニューを表示しない
    "com.apple.TextInputMenu" = {
      visible = false;
    };
  };

  # ====================================
  # Safari設定
  # ====================================
  # 注: sudo実行時はmacOSのサンドボックス保護により設定できないため自動的にスキップ

  system.defaults.CustomUserPreferences."com.apple.Safari" =
    # sudo実行を検出（SUDO_USERが設定されている場合）
    if builtins.getEnv "SUDO_USER" != "" then
      { }
    else
      {
        # タブのレイアウトをコンパクトにする（macOS Sequoia 15.xまで有効）
        EnableNarrowTabs = true;

        # キーボードショートカット（日本語環境専用）
        NSUserKeyEquivalents = {
          "サイドバーを表示" = "@s";
          "サイドバーを非表示" = "@s";
        };
      };

  # ====================================
  # Spotlight設定
  # ====================================

  system.defaults.CustomUserPreferences."com.apple.symbolichotkeys" = {
    AppleSymbolicHotKeys = {
      # Spotlightを呼び出す (cmd + space)
      "64" = {
        enabled = 1;
        value = {
          parameters = [
            65
            49
            1048576
          ];
          type = "standard";
        };
      };
    };
  };

}
