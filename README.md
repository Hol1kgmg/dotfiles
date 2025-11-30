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
export GIT_USERNAME="Hol1kgmg"
export GIT_EMAIL="you@example.com"
export GIT_SIGNINGKEY="your-key"
```

### 4. home-managerの適用
```.zsh
nix run nixpkgs#home-manager -- switch --flake .#$(whoami) --impure
```

### 5. nix-darwinの適用（システムレベル設定）
初回のみ（パスワード入力が求められます）
```.zsh
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake . --impure
```

### 6. 手動対応が必要な項目
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
sudo darwin-rebuild switch --flake . --impure
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
