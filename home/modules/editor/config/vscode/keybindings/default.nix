{
  programs.vscode.profiles.default.keybindings = [
    # ============================================
    # エディタ操作
    # ============================================

    # タブの移動
    {
      key = "alt+right";
      command = "workbench.action.nextEditor";
    }
    {
      key = "alt+left";
      command = "workbench.action.previousEditor";
    }

    # エディタグループの移動
    {
      key = "alt+shift+right";
      command = "workbench.action.focusNextGroup";
    }
    {
      key = "alt+shift+left";
      command = "workbench.action.focusPreviousGroup";
    }

    # サイドバー
    {
      key = "cmd+shift+i";
      command = "workbench.action.toggleAuxiliaryBar";
    }

    # エクスプローラーでファイルを開く
    {
      key = "right";
      command = "explorer.openAndPassFocus";
      when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
    }

    # ============================================
    # ファイル内操作
    # ============================================

    # 定義へ移動
    {
      key = "cmd+enter";
      command = "editor.action.revealDefinition";
      when = "editorHasDefinitionProvider && editorTextFocus";
    }

    # ============================================
    # エクスプローラー操作
    # ============================================

    # 新規ファイル作成
    {
      key = "cmd+n";
      command = "explorer.newFile";
      when = "explorerViewletVisible && filesExplorerFocus";
    }

    # 新規フォルダ作成
    {
      key = "cmd+shift+n";
      command = "explorer.newFolder";
      when = "explorerViewletVisible && filesExplorerFocus";
    }

    # エクスプローラーを表示
    {
      key = "cmd+shift+e";
      command = "workbench.view.explorer";
    }

    # ============================================
    # Git操作
    # ============================================

    # ステージング/ステージ解除の切り替え
    {
      key = "space";
      command = "git.stage";
      when = "scmProvider == git && scmResourceGroup == workingTree";
    }
    {
      key = "space";
      command = "git.unstage";
      when = "scmProvider == git && scmResourceGroup == index";
    }

    # 差分を表示
    {
      key = "right";
      command = "git.openChange";
      when = "scmProvider == git && scmResourceFocus";
    }

    # Gitページを表示
    {
      key = "cmd+shift+g";
      command = "workbench.view.scm";
    }

    # ============================================
    # ターミナル操作
    # ============================================

    # ターミナルを開く
    {
      key = "/";
      command = "workbench.action.terminal.focus";
    }
  ];
}
