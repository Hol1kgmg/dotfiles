# セットアップ手順

## 初回構築（新しいmacOSマシン）

### 1. Nixのインストール
```.zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. リポジトリのクローン
```.zsh
git clone https://github.com/Hol1kgmg/dotfiles.git
cd dotfiles
```

### 3. 環境変数の設定（必要に応じて）
```.zsh
export GIT_USERNAME="Your Name"
export GIT_EMAIL="you@example.com"
export GIT_SIGNINGKEY="your-key"
```

### 4. home-managerの適用
```.zsh
nix run nixpkgs#home-manager -- switch --flake .#$(whoami) --impure
```

### 5. nix-darwinの適用（システムレベル設定）
```.zsh
# 初回のみ（パスワード入力が求められます）
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake . --impure
```

---

## 日常的な使い方（構築済み環境）

### home-manager 設定を適用
```.zsh
home-manager switch --flake .#$(whoami) --impure
```

### nix-darwin 設定を適用
```.zsh
# システム設定の変更時（パスワード入力が求められます）
sudo darwin-rebuild switch --flake . --impure
```

### flake更新 + home-manager適用（一括実行）
```.zsh
nix run --impure
```

### フォーマット
```.zsh
nix fmt
```

# Directory structure
```.md
dotfiles/
├── flake.nix                    # エントリーポイント
├── flake.lock                   # 依存関係ロックファイル
├── README.md
│
├── darwin/                      # nix-darwin設定（システムレベル）
│   ├── default.nix             # darwinConfigurationのメイン
│   ├── homebrew.nix            # Homebrew管理（GUI appなど）
│   └── system/
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
