{ lib, ... }:

{
  # Caps LockキーをControlキーにリマップする設定(remapCapsLockToControl)はroot権限の
  # LaunchDaemonを必要とするためhome-managerには移行不可。nix-darwin/system/keyboard.nixを参照。
  home.activation.configureKeyboard = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Fn/地球儀キーを押したときの動作（他の選択肢: "Change Input Source", "Show Emoji & Symbols", "Start Dictation"）
    /usr/bin/defaults write com.apple.HIToolbox AppleFnUsageType -string "Do Nothing"

    # テキスト入力設定
    # 文頭を自動的に大文字にする
    /usr/bin/defaults write -g NSAutomaticCapitalizationEnabled -bool false
    # スペースバーを2回押してピリオドを入力
    /usr/bin/defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
    # 英字入力中にスペルを自動変換
    /usr/bin/defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
    # キー長押し時のアクセント文字表示を無効化
    /usr/bin/defaults write -g ApplePressAndHoldEnabled -bool false
    # キーリピート開始までの遅延（15=標準、10=最速推奨）
    /usr/bin/defaults write -g InitialKeyRepeat -int 15
    # キーリピートの速度（2=標準、1=最速）
    /usr/bin/defaults write -g KeyRepeat -int 1
    # インライン予測テキストを表示
    /usr/bin/defaults write -g NSAutomaticInlinePredictionEnabled -bool false

    # メニューバーに入力メニューを表示する
    /usr/bin/defaults write com.apple.TextInputMenu visible -bool true
  '';
}
