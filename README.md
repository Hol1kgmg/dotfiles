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

### 3. home-managerの適用
```.zsh
nix run nixpkgs#home-manager -- switch --flake .#$(whoami) --impure
```

### 4. Git設定（初回のみ）
```.zsh
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

> **Note**: Git設定は手動で行います。環境変数 `GIT_USERNAME` と `GIT_EMAIL` を設定している場合は、この手順をスキップできます。

### 5. Homebrewのインストール
```.zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> **Note**: nix-darwinの設定でHomebrewモジュールを使用しているため、事前にHomebrewのインストールが必要です。

### 6. nix-darwinの適用（システムレベル設定）
初回のみ（パスワード入力が求められます）
```.zsh
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure
```

### 7. 手動対応が必要な項目
[MANUAL_SETUP.md](./MANUAL_SETUP.md)の内容を参考に対応

---

## 日常的な使い方（構築済み環境）

### home-manager 設定を適用
```.zsh
home-manager switch --flake .#$(whoami) --impure
```

### nix-darwin 設定を適用
システム設定の変更時（パスワード入力が求められます）
```.zsh
sudo darwin-rebuild switch --flake .#default --impure
```

### flake更新 + home-manager適用（一括実行）
```.zsh
nix run --impure
```

### nixの古い環境のリセット
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

dotfilesの開発・改修については [DEVELOPMENT.md](./DEVELOPMENT.md) を参照してください。
