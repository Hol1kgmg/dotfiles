{
  # GUIアプリケーション
  homebrew.casks = [
    # 開発ツール
    "docker-desktop"
    "smoothcsv"

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
    "firefox"

    # 入力管理
    # goole-japanese-imeはRosettaが必要なので不採用
    # "keycastr"  # 入力キーを可視化するツール(普段は使わない)
    "logi-options+"
    "scroll-reverser"

    # ランチャーアプリ
    "raycast"

    # ウィンドウ管理
    "rectangle"
    "alt-tab"
    
    # bookmark管理
    "raindropio"
  ];
}
