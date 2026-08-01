# ディレクトリ構造

```
dotfiles/
├── flake.nix                    # エントリーポイント
├── flake.lock                   # 依存関係ロックファイル
├── Makefile                     # 初期環境セットアップ用（init-home, init-darwin）
├── mise.toml                    # 日常運用・devcontainer操作タスク定義（mise run）
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
├── local/                       # マシン・ユーザー個別設定
│   ├── secrets.nix              # 機密情報（.gitignore対象）
│   ├── secrets.nix.example      # 機密情報テンプレート
│   ├── home/                    # home-manager個別設定
│   │   ├── default.nix
│   │   └── git.nix              # Git個別設定（ユーザー名・メール・署名）
│   └── nix-darwin/              # nix-darwin個別設定
│       └── default.nix
│
├── nix-darwin/                  # nix-darwin設定（システムレベル）
│   ├── default.nix              # darwinConfigurationのメイン
│   ├── homebrew/                # Homebrew管理
│   │   ├── default.nix
│   │   ├── taps.nix             # Homebrew tap一覧
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
    └── modules/
        ├── default.nix
        ├── system/              # システムUI・外観設定
        │   ├── default.nix
        │   ├── browser/         # ブラウザ設定(safari)
        │   ├── dock/            # Dock設定（dockutil）
        │   ├── fonts/           # フォント設定
        │   └── window/          # ウィンドウ管理（rectangle, alt-tab, scroll-reverser）
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

### local/

マシンやユーザーごとに異なる設定を管理する。`home/` や `nix-darwin/` と同じ構造を持ち、それぞれのモジュールとして読み込まれる。
`local/secrets.nix` のみ `.gitignore` 対象で、それ以外は Git 管理対象。
初回セットアップ時は `local/secrets.nix.example` をコピーして `local/secrets.nix` を作成する。

### nix-darwin/

macOS システムレベルの設定を管理。Homebrew、キーボード設定、セキュリティ設定など。

### home/

ユーザーレベルの設定を管理。開発ツール、シェル環境、エディタなど。

## Neovim設定について

Neovimの設定は別リポジトリ [nvimrc](https://github.com/Hol1kgmg/nvimrc) で管理しています。
neovim本体・ripgrep・fd・tree-sitterはnixpkgs、nixdはnixpkgsで管理しています。
