# ディレクトリ構造

```
dotfiles/
├── flake.nix                    # エントリーポイント
├── flake.lock                   # 依存関係ロックファイル
├── .mcp.json                    # MCP server設定（Claude Code）
├── .claude/                     # Claude Code設定
├── LICENSE                      # ライセンスファイル
├── README.md                    # プロジェクト概要・セットアップ手順
├── DEVELOPMENT.md               # 開発者向けガイド
├── DEVELOPMENT_PLAN.md          # 開発計画
├── CLAUDE.md                    # Claude Code用プロジェクト指示
├── MANUAL_SETUP.md              # 手動セットアップ手順
├── DIRECTORY_STRUCTURE.md       # このファイル
│
├── nix-darwin/                  # nix-darwin設定（システムレベル）
│   ├── default.nix              # darwinConfigurationのメイン
│   ├── homebrew/                # Homebrew管理
│   │   ├── default.nix
│   │   ├── brew/                # CLI tools
│   │   └── cask/                # GUI apps
│   └── system/                  # システム設定
│       ├── default.nix
│       ├── security.nix         # セキュリティ設定
│       ├── keyboard.nix         # キーボード・テキスト入力設定
│       ├── dock.nix             # Dock設定
│       ├── finder.nix           # Finder設定
│       ├── trackpad.nix         # トラックパッド設定
│       └── custom.nix           # CustomUserPreferences（非標準設定）
│
└── home/                        # home-manager設定（ユーザーレベル）
    ├── default.nix              # home-manager統合ポイント
    ├── options.nix              # 環境変数・機密情報
    ├── secrets/                 # 機密情報管理（Git管理外）
    │   ├── default.nix          # 実際の機密情報（.gitignore対象）
    │   └── default.nix.example  # テンプレートファイル
    └── modules/
        ├── default.nix
        ├── secrets.nix          # 環境変数経由の機密情報管理
        ├── system/              # システムUI・外観設定
        │   ├── default.nix
        │   ├── browser/         # ブラウザ設定(safari)
        │   ├── dock/            # Dock設定（dockutil）
        │   └── fonts/           # フォント設定
        ├── dev/                 # 開発環境
        │   ├── default.nix
        │   ├── git.nix          # Git設定
        │   ├── mise.nix         # Mise（開発ツールバージョン管理）
        │   └── packages.nix     # 開発パッケージ定義
        ├── editor/              # エディタ設定
        │   ├── default.nix
        │   └── config/
        │       └── vscode/      # VSCode設定
        │           ├── default.nix
        │           ├── extensions/      # 拡張機能設定
        │           ├── keybindings/     # キーバインド設定
        │           └── settings/        # エディタ設定
        │               ├── default.nix
        │               ├── editor.nix   # エディタ固有設定
        │               └── languages.nix # 言語別設定
        ├── terminal/            # ターミナルエミュレータ設定
        │   ├── default.nix
        │   ├── wezterm.nix      # WezTerm設定（programs.wezterm）
        │   ├── zellij.nix       # Zellij設定（programs.zellij）
        │   └── configs/
        │       ├── wezterm/     # WezTerm Lua設定ファイル
        │       └── zellij/      # Zellij設定ファイル
        └── shell/               # シェル環境
            ├── default.nix
            ├── oh-my-posh.nix   # プロンプトテーマ設定
            ├── configs/         # シェル追加設定
            └── zsh/             # Zsh設定（モジュール分割）
                ├── default.nix  # 基本設定・統合
                ├── env.nix      # 環境変数 (.zshenv)
                └── aliases.nix  # エイリアス定義
```

## 主要ディレクトリの説明

### .claude/

Claude Code 設定ディレクトリ。Claude AI アシスタントの動作設定を管理。

### nix-darwin/

macOS システムレベルの設定を管理。Homebrew、キーボード設定、セキュリティ設定など。

### home/

ユーザーレベルの設定を管理。開発ツール、シェル環境、エディタなど。
