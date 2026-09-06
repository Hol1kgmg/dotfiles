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
    "claude-code"
    "copilot-cli"

    # ターミナル
    "wezterm"
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
    "macskk"
    # goole-japanese-imeはRosettaが必要なので不採用
    # "keycastr"  # 入力キーを可視化するツール(普段は使わない)
    "scroll-reverser"
    # "hammerspoon" # chrome browser用 sidebarのショートカット有効化ツール
    # "trex" # vicinaeで使用

    # ランチャーアプリ
    "raycast"
    # "vicinae"

    # ウィンドウ管理
    "rectangle"
    "dockdoor"
  ];
}
