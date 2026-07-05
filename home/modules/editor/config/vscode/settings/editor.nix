{ pkgs, ...}:

{
  programs.vscode.profiles.default.userSettings = {
    # アクセシビリティ
    "editor.accessibilitySupport" = "on";

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

    # Git設定
    "git.openRepositoryInParentFolders" = "always";
    "git.confirmSync" = false;

    # メモリ最適化
    "files.watcherExclude" = {
      "**/node_modules/**" = true;
      "**/.git/**" = true;
      "**/dist/**" = true;
    };
    "editor.minimap.enabled" = false;
    "workbench.enableExperiments" = false;

    # アクセシビリティ：シグナルサウンドを無効化
    "accessibility.signals.chatEditModifiedFile"= { sound = "off"; };
    "accessibility.signals.lineHasError"= { sound = "off"; };
    "accessibility.signals.chatRequestSent"= { sound = "off"; };
    "accessibility.signals.clear"= { sound = "off"; };
    "accessibility.signals.lineHasFoldedArea"= { sound = "off"; };
    "accessibility.signals.lineHasInlineSuggestion"= { sound = "off"; };
    "accessibility.signals.noInlayHints"= { sound = "off"; };
    "accessibility.signals.notebookCellCompleted"= { sound = "off"; };
    "accessibility.signals.onDebugBreak"= { sound = "off"; };
    "accessibility.signals.notebookCellFailed"= { sound = "off"; };
    "accessibility.signals.taskCompleted"= { sound = "off"; };
    "accessibility.signals.terminalQuickFix"= { sound = "off"; };
    "accessibility.signals.terminalCommandFailed"= { sound = "off"; };
    "accessibility.signals.terminalBell"= { sound = "off"; };
    "accessibility.signals.taskFailed"= { sound = "off"; };
    "accessibility.signals.lineHasWarning"= { sound = "off"; };
    "accessibility.signals.lineHasBreakpoint"= { sound = "off"; };
    "accessibility.signals.diffLineModified"= { sound = "off"; };
    "accessibility.signals.diffLineInserted"= { sound = "off"; };
    "accessibility.signals.diffLineDeleted"= { sound = "off"; };
    "accessibility.signals.voiceRecordingStopped"= { sound = "off"; };
    "accessibility.signals.terminalCommandSucceeded"= { sound = "off"; };
    "accessibility.signals.chatResponseReceived"= { sound = "off"; };
    "accessibility.signals.chatUserActionRequired"= { sound = "off"; };
    "accessibility.signals.codeActionApplied"= { sound = "off"; };
    "accessibility.signals.codeActionTriggered"= { sound = "off"; };
    "accessibility.signals.editsKept"= { sound = "off"; };
    "accessibility.signals.editsUndone"= { sound = "off"; };
    "accessibility.signals.nextEditSuggestion"= { sound = "off"; };
    "accessibility.signals.positionHasError"= { sound = "off"; };
    "accessibility.signals.positionHasWarning"= { sound = "off"; };
    "accessibility.signals.progress"= { sound = "off"; };
    "accessibility.signals.voiceRecordingStarted"= { sound = "off"; };

    # todo-tree: Nixでインストールしたripgrepを指定
    "todo-tree.ripgrep.ripgrep" = "${pkgs.ripgrep}/bin/rg";


    # marp markdown
    "markdown.marp.enableHtml" = true;

    # その他
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "workbench.startupEditor" = "none";
    "telemetry.telemetryLevel" = "off";
  };
}
