# Development Plan

## 作業フロー

各タスクを進める際の標準的なワークフロー：

1. **プランドキュメント作成** - タスク専用の`.md`ファイルを作成（例: `vscode-keybindings-plan.md`）
2. **プランに記入** - 実装内容、要件、設計をドキュメントに記入
3. **実装** - プランに基づいて実装を進める
4. **完了** - プランドキュメントを削除
5. **DEVELOPMENT_PLANを更新** - 該当タスクを完了としてマーク

## 未完了タスク

### 1. Neovim設定
- [ ] Neovimの基本設定を追加
- [ ] `home/modules/editor/config/neovim/`にディレクトリ構造を作成
- [ ] プラグイン管理の設定
- [ ] キーマッピングの設定

### 2. GitHub MCP（優先度: 低）
- [ ] GitHub MCPの設定を追加
- [ ] 必要な認証情報の設定
- [ ] MCPサーバーの統合

**Note:** 各リポジトリ単位でトークン管理が推奨されているため、dotfilesでの一元管理には適していない。そのため優先度を低に設定。

## 完了タスク

### ghqとzoxideの導入 ✅
- [x] ghqの設定追加（リポジトリ管理ツール）
- [x] zoxideの設定追加（高速ディレクトリ移動）
- [x] `home/modules/dev/ghq-zoxide.nix`に統合実装
- [x] ghqとzoxideの自動同期機能（`__zoxide_add_missing`）
- [x] カスタム`cd`と`cdi`コマンドの実装
- [x] ghqルートディレクトリを`~/dev`に設定

### VSCode設定 ✅
- [x] ディレクトリ構造の改修
- [x] 拡張機能の整理
- [x] 設定ファイルの分割（editor.nix、languages.nix）
- [x] 不要な設定の削除（200行→46行、77%削減）
- [x] **キーバインドの設定**（14個のキーバインド実装）

### Git設定管理 ✅
- [x] `home/secrets.nix.example`テンプレートの作成
- [x] `home/secrets.nix`の作成（Git管理外）
- [x] `.gitignore`に`home/secrets.nix`を追加
- [x] `home/modules/secrets.nix`の実装（環境変数経由でGit情報を管理）
- [x] Git情報のNix管理への移行（オプション2: home.sessionVariables方式）
