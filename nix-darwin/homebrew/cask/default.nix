{
  # GUIアプリケーション
  homebrew.casks = [
    # 開発ツール
    "visual-studio-code"
    "docker-desktop"
    "smoothcsv"
    "obsidian"
    "Hol1kgmg/localhost-top/localhost-top"

    # AIエージェント
    "stablyai/orca/orca" # 試用中 (docs/adr/terminal-env/0007-trial-orca.md)

    # ターミナル
    "wezterm"
    "kitty"              # 試用中 (docs/adr/terminal-env/0006-trial-kitty.md)
    # "wezterm@nightly"  # NixのmacOSビルドに問題があるためHomebrewで管理
    # "cmux"             # バグが多かったので、導入見送り
    # "ghostty"

    # ファイル管理
    "symboliclinker"
    "appcleaner"

    # ブラウザ
    "google-chrome"
    "google-chrome@canary"

    # 入力管理
    # "macskk" # 撤退 (docs/adr/input-env/0003-retire-macskk.md)
    # goole-japanese-imeはRosettaが必要なので不採用
    # "keycastr"  # 入力キーを可視化するツール(普段は使わない)
    "scroll-reverser"
    # "hammerspoon" # chrome browser用 sidebarのショートカット有効化ツール
    # "trex" # vicinaeで使用

    # 音声入力
    "aqua-voice"

    # ランチャーアプリ
    "raycast"
    # "vicinae"

    # ウィンドウ管理
    "rectangle"
    "dockdoor"

    # パスワード管理
    "1password"
    "1password-cli"
  ];
}
