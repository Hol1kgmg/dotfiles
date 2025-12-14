# セットアップ手順

## 初回構築（新しい macOS マシン）

### 1. Nix のインストール

```.zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. リポジトリのクローン

```.zsh
git clone https://github.com/Hol1kgmg/dotfiles.git
cd dotfiles
```

### 3. home-manager の適用

```.zsh
nix run nixpkgs#home-manager -- switch --flake .#$(whoami) --impure
```

### 4. Git 設定（初回のみ）

```.zsh
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

> **Note**: Git 設定は手動で行います。環境変数 `GIT_USERNAME` と `GIT_EMAIL` を設定している場合は、この手順をスキップできます。

### 5. Homebrew のインストール

```.zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> **Note**: nix-darwin の設定で Homebrew モジュールを使用しているため、事前に Homebrew のインストールが必要です。

### 6. nix-darwin の初回セットアップ（システムレベル設定）

初回のみ（パスワード入力が求められます）

```.zsh
sudo -H nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure
```

> **Note**: 初回は sudo 実行のため、macOS のサンドボックス保護により Safari 設定がスキップされます。次のステップで適用されます。

### 7. Safari 設定の適用（初回セットアップ後）

初回セットアップ完了後、Safari 設定を適用するため通常権限で実行

```.zsh
darwin-rebuild switch --flake .#default --impure
```

> **Note**: sudo 実行時は macOS のサンドボックス保護によりユーザーの Safari 設定が書き込めないため、通常権限での実行が必要です。

### 8. 手動対応が必要な項目

[MANUAL_SETUP.md](./MANUAL_SETUP.md)の内容を参考に対応

---

## 日常的な使い方（構築済み環境）

### home-manager 設定を適用

```.zsh
home-manager switch --flake .#$(whoami) --impure
```

### nix-darwin 設定を適用

#### 通常の設定適用（Safari 設定を含む）

```.zsh
darwin-rebuild switch --flake .#default --impure
```

#### システムレベルの設定変更時のみ（パスワード入力が求められます）

```.zsh
sudo darwin-rebuild switch --flake .#default --impure
```

> **Note**: Safari 設定は通常権限での実行時のみ適用されます。sudo 実行が必要なのはシステムレベルの設定を変更する場合のみです。

### flake 更新 + home-manager 適用（一括実行）

```.zsh
nix run --impure
```

### nix の古い環境のリセット

```.zsh
nix store gc
```

### フォーマット

```.zsh
nix fmt
```

---

## ディレクトリ構造

詳細は [DIRECTORY_STRUCTURE.md](./DIRECTORY_STRUCTURE.md) を参照してください。

---

## 開発者向け情報

dotfiles の開発・改修については [DEVELOPMENT.md](./DEVELOPMENT.md) を参照してください。
