{
  programs.vscode.profiles.default.userSettings = {
    # フォーマット設定
    "editor.formatOnSave" = true;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";

    # 保存時の動作
    "files.trimTrailingWhitespace" = true;
    "files.insertFinalNewline" = true;
    "files.trimFinalNewlines" = true;

    # ファイル除外設定（Nix/direnv関連のみ）
    "files.exclude" = {
      "**/node_modules" = true;
      "**/.direnv" = true;
      "**/result" = true;  # Nix build結果
    };

    # テーマ設定
    "workbench.iconTheme" = "catppuccin-mocha";
    "workbench.colorTheme" = "Kanagawa Wave";  # Kanagawaテーマを使用

    # ターミナル設定
    "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font Mono'";
    "terminal.integrated.fontSize" = 13;

    # その他
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "workbench.startupEditor" = "none";
    "telemetry.telemetryLevel" = "off";
  };
}
