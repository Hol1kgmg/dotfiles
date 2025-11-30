# ディレクトリ構造

```
dotfiles/
├── flake.nix                    # エントリーポイント
├── flake.lock                   # 依存関係ロックファイル
├── .mcp.json                    # MCP server設定（Claude Code）
├── README.md                    # プロジェクト概要・セットアップ手順
├── DEVELOPMENT.md               # 開発者向けガイド
├── CLAUDE.md                    # Claude Code用プロジェクト指示
├── MANUAL_SETUP.md              # 手動セットアップ手順
├── DIRECTORY_STRUCTURE.md       # このファイル
│
├── nix-darwin/                  # nix-darwin設定（システムレベル）
│   ├── default.nix              # darwinConfigurationのメイン
│   ├── homebrew/                # Homebrew管理
│   │   ├── default.nix
│   │   ├── brew/                # CLI tools
│   │   │   └── default.nix
│   │   └── cask/                # GUI apps
│   │       └── default.nix
│   └── system/                  # システム設定
│       ├── default.nix
│       ├── keyboard.nix         # キーボード・ショートカット
│       └── security.nix         # セキュリティ設定
│
└── home/                        # home-manager設定（ユーザーレベル）
    ├── default.nix              # home-manager統合ポイント
    ├── options.nix              # 環境変数・機密情報
    └── modules/
        ├── default.nix
        ├── dev/                 # 開発環境
        │   ├── default.nix
        │   └── git.nix          # Git設定
        ├── editor/              # エディタ設定
        │   └── default.nix      # 将来的にvscode、neovim等を追加予定
        ├── terminal/            # ターミナルエミュレータ設定
        │   ├── default.nix
        │   ├── wezterm.nix      # WezTerm設定（programs.wezterm）
        │   ├── zellij.nix       # Zellij設定（programs.zellij）
        │   └── configs/
        │       └── wezterm/     # WezTerm Lua設定ファイル
        │           ├── wezterm.lua    # メイン設定（フォント、透過、タブ等）
        │           └── keybinds.lua   # キーバインド設定
        └── shell/               # シェル環境
            ├── default.nix
            └── zsh/             # Zsh設定（モジュール分割）
                ├── default.nix  # 基本設定・統合
                ├── env.nix      # 環境変数 (.zshenv)
                ├── aliases.nix  # エイリアス定義
                └── init.nix     # カスタム初期化 (.zshrc)
```

## 主要ディレクトリの説明

### nix-darwin/
macOSシステムレベルの設定を管理。Homebrew、キーボード設定、セキュリティ設定など。

### home/
ユーザーレベルの設定を管理。開発ツール、シェル環境など。

### home/modules/shell/zsh/
Zsh設定を役割ごとに分割：
- **env.nix**: 環境変数（PATH等）
- **aliases.nix**: コマンドエイリアス
- **init.nix**: カスタム関数・初期化スクリプト
- **default.nix**: 上記を統合し、基本設定を定義
