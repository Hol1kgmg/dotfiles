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

    # TODO: fn / 地球儀キーを押して : 何もしない
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

    # TODO: 未実装項目
    # - メニューバーに入力メニューを表示 : false
    # - caps lockキーでABC入力モードと切り替える : false
    # - 書類ごとに入力ソースを自動で切り替える : false
    # - インライン予測テキストを表示 : false
    # - 提案された返信を表示 : false
  };

  # ========================================
  # キーボードショートカット設定
  # ========================================

  # TODO: 未実装項目
  # - Launchpad表示 : ⌥ + space
  # - アプリのショートカット
  #     - safari : サイドバーを表示/非表示 : cmd + s
  # - フルスクリーンの表示 : option + a
}
