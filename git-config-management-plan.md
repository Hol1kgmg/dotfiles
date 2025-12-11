# Git情報のNix管理 - 設計プラン

## 目的

- Git情報（user.name, user.email, signingkey）をNixで管理したい
- `.zshenv`などに手動で環境変数を書きたくない
- 機密情報をリポジトリにコミットしたくない
- dotfiles全体をNix管理に統一したい

## 現状分析

### 現在の状態
- **~/.gitconfig（手動管理）**: user.name, user.email
- **~/.config/git/config（Nix管理）**: その他の設定（editor, gpg, init, pull, push）
- **home/options.nix**: 環境変数から値を取得（現在は全て空）
- **home/modules/dev/git.nix**: 環境変数が設定されている場合のみuser情報を追加

### 問題点
1. ハイブリッド運用で管理が分散している
2. 環境変数が未設定のため、Nix管理が機能していない
3. 新環境セットアップ時に手動でgit configが必要

## 設計選択肢

### オプション1: secrets.nixで直接管理（既に実装済み）

```nix
# home/secrets.nix（Git管理外）
{
  gitUsername = "Hol1kgmg";
  gitEmail = "abdevs.horisho@icloud.com";
  gitSigningkey = "";
}

# home/options.nix
let
  secrets = import ./secrets.nix;
in
{
  gitUsername = secrets.gitUsername;
  gitEmail = secrets.gitEmail;
  gitSigningkey = secrets.gitSigningkey;
}
```

**メリット:**
- ✅ Nixで完全管理、宣言的
- ✅ secrets.nix.exampleでテンプレート提供
- ✅ 機密情報はGit管理外

**デメリット:**
- ❌ ~/.gitconfigを削除する必要がある
- ❌ `git config --global`が使えなくなる（Nix管理の設定が上書きされる）
- ❌ 変更の度に`home-manager switch`が必要（即座の反映不可）
- ❌ 複数Gitアカウントの使い分けが複雑化

**セットアップ手順:**
```bash
cp home/secrets.nix.example home/secrets.nix
vim home/secrets.nix  # 編集
rm ~/.gitconfig  # 削除必須
home-manager switch --flake .#$(whoami) --impure
```

---

### オプション2: home.sessionVariablesで環境変数管理

```nix
# home/secrets.nix（Git管理外）
{
  gitUsername = "Hol1kgmg";
  gitEmail = "abdevs.horisho@icloud.com";
  gitSigningkey = "";
}

# home/default.nix または専用モジュール
let
  secrets = import ./secrets.nix;
in
{
  home.sessionVariables = {
    GIT_USERNAME = secrets.gitUsername;
    GIT_EMAIL = secrets.gitEmail;
    GIT_SIGNINGKEY = secrets.gitSigningkey;
  };
}

# home/options.nix は現状のまま（環境変数から取得）
```

**メリット:**
- ✅ Nixで管理しつつ、既存の仕組み（環境変数経由）を活用
- ✅ git.nixの変更不要
- ✅ ~/.gitconfigとの共存可能（優先順位で制御）
- ✅ 他のツールからも環境変数を参照可能

**デメリット:**
- ❌ 環境変数を経由する点では手動設定と変わらない
- ❌ シェルを再起動しないと反映されない

**セットアップ手順:**
```bash
cp home/secrets.nix.example home/secrets.nix
vim home/secrets.nix  # 編集
home-manager switch --flake .#$(whoami) --impure
# シェルを再起動
```

---

### オプション3: ハイブリッド運用継続（現状維持）

```bash
# 手動でgit configを設定
git config --global user.name "Hol1kgmg"
git config --global user.email "abdevs.horisho@icloud.com"

# その他の設定はNix管理
```

**メリット:**
- ✅ 一般的なGit設定方法
- ✅ 即座の変更が可能
- ✅ 複数アカウント管理が容易

**デメリット:**
- ❌ Nix管理に統一できない
- ❌ 新環境セットアップ時に手動作業が必要
- ❌ 機密情報が~/.gitconfigに平文保存

---

## 推奨アプローチ

**オプション2（home.sessionVariables）を推奨**

理由:
1. **既存の仕組みを活用** - git.nixの変更不要、options.nixの仕組みがそのまま使える
2. **柔軟性** - 必要に応じて~/.gitconfigとの共存も可能
3. **変更が最小限** - リスクが低い
4. **Nix管理** - secrets.nixでの一元管理を実現

## 実装プラン（オプション2）

### 1. ファイル作成
- [x] `home/secrets.nix.example` - テンプレート
- [x] `home/secrets.nix` - 実際の情報（Git管理外）
- [x] `.gitignore`に`home/secrets.nix`を追加

### 2. 設定追加

**新規ファイル: `home/modules/secrets.nix`**
```nix
{ config, lib, ... }:
let
  secrets = if builtins.pathExists ../secrets.nix
    then import ../secrets.nix
    else { gitUsername = ""; gitEmail = ""; gitSigningkey = ""; };
in
{
  home.sessionVariables = lib.mkIf (secrets.gitUsername != "") {
    GIT_USERNAME = secrets.gitUsername;
    GIT_EMAIL = secrets.gitEmail;
    GIT_SIGNINGKEY = lib.mkIf (secrets.gitSigningkey != "") secrets.gitSigningkey;
  };
}
```

**`home/modules/default.nix`に追加**
```nix
{
  imports = [
    ./secrets.nix  # 追加
    ./dev
    ./editor
    # ...
  ];
}
```

### 3. options.nixは変更不要
現状のまま（環境変数から取得）を維持

### 4. セットアップ手順更新
README.mdの「4. Git設定（初回のみ）」を更新

## 次のステップ

1. このプランをレビュー
2. アプローチの承認
3. 実装開始
4. 動作確認
5. README.md更新
