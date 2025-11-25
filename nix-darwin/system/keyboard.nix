{
  # ========================================
  # キーボード設定
  # ========================================

  # fn / 地球儀キーを押して : 何もしない (0 = Nothing, 1 = Change Input Source, 2 = Show Emoji, 3 = Dictation)
  system.defaults.HIToolbox.AppleFnUsageType = 0;

  # ========================================
  # テキスト入力設定
  # ========================================

  system.defaults.NSGlobalDomain = {
    # 英字入力中にスペルを自動変換 : false
    NSAutomaticSpellingCorrectionEnabled = false;

    # 文頭を自動的に大文字にする : false
    NSAutomaticCapitalizationEnabled = false;

    # スペースバーを2回押してピリオドを入力 : false
    NSAutomaticPeriodSubstitutionEnabled = false;

    # スマートダッシュ置換 : false
    NSAutomaticDashSubstitutionEnabled = false;

    # スマート引用符置換 : false
    NSAutomaticQuoteSubstitutionEnabled = false;
  };

  # ========================================
  # 修飾キー設定
  # ========================================

  # Caps Lock → Control キーに変更
  system.defaults.keyboard.remapCapsLockToControl = true;

  # ========================================
  # 未対応項目（nix-darwinで直接サポートされていない）
  # ========================================
  # - メニューバーに入力メニューを表示 : 要調査
  # - caps lockキーでABC入力モードと切り替える : 要調査
  # - 書類ごとに入力ソースを自動で切り替える : 要調査
  # - インライン予測テキストを表示 : 要調査
  # - 提案された返信を表示 : 要調査
  # - Launchpad表示ショートカット (⌥+Space) : 要調査
  # - Safari サイドバーショートカット : アプリ固有設定
  # - フルスクリーン表示 (⌥+A) : 要調査
}
