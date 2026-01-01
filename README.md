![Neovim Screenshot](assets/nvim_screen_shot.png)

# セットアップ手順

## 初回構築（新しい macOS マシン）

### 1. フルディスクアクセスの設定

Safari 設定などの自動適用には、ターミナルにフルディスクアクセス権限が必要です。

```.zsh
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
```

設定画面で使用しているターミナルアプリ（WezTerm、Terminal.app、iTerm2 など）を追加し、ターミナルを再起動してください。

> **Note**: ターミナルの再起動後、次のステップに進んでください。

### 2. Nix のインストール

```.zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 3. リポジトリのクローン

```.zsh
git clone https://github.com/Hol1kgmg/dotfiles.git
cd dotfiles
```

### 4. Git 設定（初回のみ）

Git のユーザー情報を設定します。

```.zsh
cp home/secrets/default.nix.example home/secrets/default.nix
```

gitUsername と gitEmail を編集

```.zsh
vim home/secrets/default.nix
```

> **Note**: `home/secrets/default.nix` は `.gitignore` されているため、リポジトリにコミットされません。

### 5. home-manager の適用

```.zsh
nix run nixpkgs#home-manager -- switch --flake .#$(whoami) --impure
```

### 6. Homebrew のインストール

```.zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

> **Note**: nix-darwin の設定で Homebrew モジュールを使用しているため、事前に Homebrew のインストールが必要です。

### 7. nix-darwin の初回セットアップ（システムレベル設定）

初回のみ（パスワード入力が求められます）

```.zsh
sudo -H nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#default --impure
```

### 8. home-manager の再適用（Homebrew アプリへの設定反映）

nix-darwin で Homebrew 経由のアプリ（Rectangle など）がインストールされた後、設定を反映させます。

```.zsh
home-manager switch --flake .#$(whoami) --impure
```

### 9. 手動対応が必要な項目

[MANUAL_SETUP.md](./MANUAL_SETUP.md)の内容を参考に対応

---

## 日常的な使い方（構築済み環境）

### home-manager 設定を適用

```.zsh
home-manager switch --flake .#$(whoami) --impure
```

### nix-darwin 設定を適用

```.zsh
sudo darwin-rebuild switch --flake .#default --impure
```

### flake 更新 + home-manager 適用（一括実行）

> **⚠️ 警告**: このコマンドは `flake.lock` を最新版に更新します。依存関係の破壊的変更により、動作していた機能が壊れる可能性があります。日常的な設定変更には上記の `home-manager switch` または `darwin-rebuild switch` を使用してください。

```.zsh
nix run .#default --impure
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

## 各機能の使い方を調べる

各ツールやコマンドの使用方法を知りたい場合は、`help`で検索してください。

設定ファイル内にヘルプコメントが記載されています。

---

## トラブルシューティング

問題が発生した場合は、[SETUP_TROUBLESHOOTING.md](./SETUP_TROUBLESHOOTING.md) を参照してください。

---

## ディレクトリ構造

詳細は [DIRECTORY_STRUCTURE.md](./DIRECTORY_STRUCTURE.md) を参照してください。

---

## 開発者向け情報

dotfiles の開発・改修については [DEVELOPMENT.md](./DEVELOPMENT.md) を参照してください。
