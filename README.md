# Quick Start
1. git clone 
```.zsh
git clone https://github.com/Hol1kgmg/dotfiles.git
```

2. set up
nix flaskのupdate専用コマンド
```.zsh
nix run .#update
```
<!--TODO-->

3.Directory structure
```.md
dotfiles/
├── flake.nix                    # エントリーポイント
├── flake.lock                   # 依存関係ロックファイル
├── README.md
│
├── darwin/                      # nix-darwin設定（システムレベル）
│   ├── default.nix             # darwinConfigurationのメイン
│   ├── system.nix              # システム全体の設定
│   ├── homebrew.nix            # Homebrew管理（GUI appなど）
│   └── modules/
│       ├── preferences.nix     # macOS Defaults（Dock, Finder等）
│       ├── keyboard.nix        # キーボード・ショートカット
│       ├── networking.nix      # ネットワーク設定
│       └── fonts.nix           # システムフォント
│
├── home/                        # home-manager設定（ユーザーレベル）
│   ├── default.nix             # home-manager統合ポイント
│   ├── home.nix                # ユーザー環境のメイン設定
│   └── modules/
│       ├── dev/                # 開発環境
│       │   ├── default.nix
│       │   └── tools/
│       │       ├── default.nix
│       │       └── git.nix
│       ├── editor/             # エディタ
│       │   ├── default.nix
│       │   └── neovim.nix
│       ├── shell/              # シェル環境
│       │   ├── default.nix
│       │   ├── zsh.nix
│       │   └── oh-my-posh.nix
│       └── gui/                # GUIアプリ設定
│           ├── default.nix
│           ├── wezterm.nix
│           └── vscode.nix
│
├── hosts/                       # ホスト固有設定
│   ├── macbook-pro/
│   │   ├── default.nix         # このホストの設定統合
│   │   └── hardware.nix        # ハードウェア固有設定
│   └── macbook-air/
│       ├── default.nix
│       └── hardware.nix
│
├── options/                     # 環境変数・機密情報
│   ├── default.nix
│   └── secrets.nix.example     # テンプレート
│
└── lib/                         # 共通ユーティリティ
    ├── default.nix
    └── helpers.nix
```
