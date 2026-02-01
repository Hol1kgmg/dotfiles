{
  # GUIアプリケーション
  homebrew.casks = [
    # 開発ツール
    "docker-desktop"
    "smoothcsv"
    "devtoys"

    # AIエージェント
    "claude-code"
    "copilot-cli"

    # ターミナル
    "wezterm"  # NixのmacOSビルドに問題があるためHomebrewで管理

    # ファイル管理
    "symboliclinker"
    "appcleaner"

    # ブラウザ
    "google-chrome"

    # 入力管理
    # goole-japanese-imeはRosettaが必要なので不採用
    # "keycastr"  # 入力キーを可視化するツール(普段は使わない)
    "logi-options+"

    # ウィンドウ管理
    "rectangle"
    "autoraiseapp"  # dimentium/autoraise tap
  ];
}
