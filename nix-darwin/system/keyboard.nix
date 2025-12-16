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

    # ========================================
    # キーボードショートカット設定の注意
    # ========================================
    # 警告: "com.apple.symbolichotkeys" を設定すると、AppleSymbolicHotKeys全体が上書きされます。
    # 一部のショートカットだけを設定した場合、他のデフォルトショートカット
    # (Mission Control、Expose、Spotlightなど)が無効になります。
    #
    # 特定のショートカットを変更したい場合は、必要なショートカットを全て明示的に定義してください。
    # デフォルト設定を使いたい場合は、com.apple.symbolichotkeysの設定を追加しないでください。
  };

}
