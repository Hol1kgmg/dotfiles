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

    # キーリピート開始までの遅延（15が標準、小さいほど速い）
    InitialKeyRepeat = 12;

    # キーリピートの速度（2が標準、小さいほど速い）
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

  # ========================================
  # 今後の実装予定（Phase 3）
  # ========================================
  # 詳細は keyboard_implementation_plan.md を参照
  #
  # Phase 3: キーボードショートカット設定（要詳細調査）
  # - Launchpad表示 : ⌥ + space
  # - アプリのショートカット（Safari等）
  # - フルスクリーンの表示 : option + a
  #   → system.defaults.CustomUserPreferences."com.apple.symbolichotkeys"
  #
  # 対応不要項目（ユーザー要望により）:
  # - caps lockキーでABC入力モードと切り替える
  # - 書類ごとに入力ソースを自動で切り替える
  # - 提案された返信を表示

}
