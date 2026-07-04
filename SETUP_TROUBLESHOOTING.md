# トラブルシューティング概要

セットアップ時や日常利用で発生する問題の対処法をまとめています。

---

# アプリ

## WezTerm の設定が反映されない

### 症状

weztermを起動しても、透明度・ぼかし効果・ウィンドウ装飾などの設定が反映されない。

### 原因

`~/.wezterm.lua`が存在し、`~/.config/wezterm/wezterm.lua`よりも優先的に読み込まれている。

weztermは以下の優先順位で設定ファイルを読み込みます：
1. `~/.wezterm.lua` （優先度: 高）
2. `~/.config/wezterm/wezterm.lua` （優先度: 低）

### 解決方法

`~/.wezterm.lua`を削除してweztermを再起動します：

```zsh
rm ~/.wezterm.lua
```

---

# Neovim

## fff.nvim のバイナリダウンロードエラー

### 症状

Neovim起動時に以下のようなエラーが表示される：

```
Error executing vim.schedule lua callback: ...
Failed to load fff.rust module: ...
Failed to load fff rust backend.
Error: No valid library found in any search path
```

### 原因

fff.nvimのRustバックエンドバイナリが正しくダウンロードまたはビルドされていない。

### 解決方法

#### 方法1: 手動ダウンロード（推奨）

1. Neovimを起動
   ```zsh
   nvim
   ```

2. バイナリをダウンロード
   ```vim
   :lua require("fff.download").download_or_build_binary()
   ```

3. Neovimを再起動

4. 動作確認
   ```vim
   :FFFHealth
   ```
   または
   ```
   <Space>ff
   ```

#### 方法2: プラグインの再ビルド

```vim
:Lazy build fff.nvim
```

#### 方法3: プラグインの再インストール

```vim
:Lazy clean fff.nvim
:Lazy sync
```

#### 方法4: 上記の方法がすべて失敗する場合（バイナリファイル破損時）

バイナリファイルが破損している場合（`segment '__DATA_CONST' load command content extends beyond end of file`というエラー）、ターミナルから直接削除して再インストールします。

```zsh
# 1. 破損したバイナリを削除
rm -rf ~/.local/share/nvim/lazy/fff.nvim/target

# 2. プラグインとキャッシュを完全削除
rm -rf ~/.local/share/nvim/lazy/fff.nvim
rm -rf ~/.cache/nvim

# 3. プラグインを再インストール
nvim --headless "+Lazy! sync" +qa

# 4. 動作確認
nvim --headless "+lua require('fff')" "+lua print('fff.nvim loaded successfully')" +qa
```

エラーなく`fff.nvim loaded successfully`と表示されれば成功です。

### 確認コマンド

- **バイナリの存在確認**
  ```zsh
  ls -la ~/.local/share/nvim/lazy/fff.nvim/target/release/
  ```
  `libfff_nvim.dylib`（macOS）または`libfff_nvim.so`（Linux）が存在するはず

- **健全性チェック**
  ```vim
  :FFFHealth
  ```

---

## snacks.nvim の LazyGit が起動しない

### 症状

`<Space>gg`を押してもLazyGitが起動しない。

### 原因

`lazygit`コマンドがPATHに存在しない。

### 解決方法

1. lazygitのインストール確認
   ```zsh
   which lazygit
   ```

2. インストールされていない場合、home-manager switchを実行
   ```zsh
   home-manager switch --flake .#$(whoami) --impure
   ```

3. 新しいシェルセッションを開始
   ```zsh
   exec $SHELL
   ```

---

## home-manager switch 後に設定が反映されない

### 症状

`home-manager switch --flake .#$(whoami) --impure` を実行しても、Neovimのキーマップやプラグイン設定の変更が反映されない。

### 原因

Neovimは起動高速化のため、Luaファイルをコンパイルしたbytecodeを `~/.cache/nvim/luac/` にキャッシュしています。設定ファイルが更新されても、古いbytecodeキャッシュが優先して読み込まれるため、変更が反映されません。

### 解決方法

Neovimを終了してから以下を実行し、キャッシュを削除します：

```zsh
rm -rf ~/.local/state/nvim/ ~/.cache/nvim/luac/
```

その後、Neovimを再起動してください。

---

## プラグインの一般的なトラブルシューティング

### lazy.nvimの状態確認

```vim
:Lazy
```

### lazy.nvimのログ確認

```vim
:Lazy log
```

### プラグインの健全性チェック

```vim
:checkhealth
```

特定のプラグインのみチェック：
```vim
:checkhealth fff
:checkhealth snacks
```

### lazy.nvimのキャッシュクリア

```vim
:Lazy clean
:Lazy sync
```

---

# nix-darwin / darwin-rebuild

## `brew bundle` でヘルプテキストが表示されてビルドが失敗する

### 症状

`sudo darwin-rebuild switch --flake .#default --impure` 実行時に以下のようなメッセージが表示されてビルドが失敗する：

```
Homebrew bundle...
Usage: brew bundle [subcommand]

Bundler for non-Ruby dependencies from Homebrew, Homebrew Cask, ...
```

### 原因

Homebrew 5.x 以降、`brew bundle` はサブコマンドなしでは動作しなくなった（`brew bundle install` と明示的な指定が必要）。nix-darwin の古いバージョンがサブコマンドなしで呼び出しているため、互換性の問題が発生する。

### 解決方法

nix-darwin を最新版に更新する：

```zsh
# nix-darwin のみ更新（推奨）
nix flake update nix-darwin

# または全 inputs を更新
nix flake update

# 再ビルド
sudo darwin-rebuild switch --flake .#default --impure
```

---

## サードパーティ tap のツールを追加するとビルドが失敗する

### 症状

公式 tap 以外のツール（例: `hashicorp/tap/terraform` のような形式）を `nix-darwin/homebrew/brew/` や `cask/` に追加して `sudo darwin-rebuild switch --flake .#default --impure` を実行すると、以下のようなエラーでビルドが失敗する：

```
Error: Tap <owner>/<tap名> not installed
```

または `brew tap` を手動実行しても失敗する：

```
Error: Tap ... is read-only
```

### 原因

この dotfiles では `nix-homebrew` の `mutableTaps = false` により、tap を flake input として固定管理している（`nix-darwin/homebrew/taps.nix`）。そのため：

- Homebrew が未登録の tap を自動取得できない
- `brew tap` / `brew untap` による手動操作もできない（tap の実体は nix store への read-only シンボリックリンク）

登録済みなのは公式の `homebrew/homebrew-core`（CLI）と `homebrew/homebrew-cask`（GUI）のみ。この 2 つに収録されたツールはリストに名前を書くだけで導入できるが、サードパーティ tap のツールは tap 自体の登録が必要。

### 解決方法

3 箇所を変更して tap を flake で固定登録する：

1. `flake.nix` の inputs に tap リポジトリを宣言

   ```nix
   homebrew-<名前> = {
     url = "github:<owner>/homebrew-<repo>";
     flake = false;
   };
   ```

2. `nix-darwin/homebrew/taps.nix` の `taps` に登録

   ```nix
   "<owner>/homebrew-<repo>" = inputs.homebrew-<名前>;
   ```

3. `brew/` または `cask/` のリストに完全修飾名で追加

   ```nix
   "<owner>/<tap名>/<ツール名>"
   ```

その後、lock ファイルを更新して再ビルド：

```zsh
nix flake lock
sudo darwin-rebuild switch --flake .#default --impure
```

tap を削除する場合も同様に、上記 3 箇所から削除して `nix flake lock` → 再ビルドする（`onActivation.cleanup = "uninstall"` によりツール本体と tap も自動削除される）。

### 補足: 新規ファイル作成後に `path '...' does not exist` エラー

tap 登録のために新しい `.nix` ファイルを作成した直後、評価時に以下のエラーが出ることがある：

```
error: path '/nix/store/...-source/nix-darwin/homebrew/taps.nix' does not exist
```

flake は Git 管理下のファイルのみをソースとして扱うため、**未追跡（untracked）のファイルは flake から見えない**。以下でステージングすれば解決する：

```zsh
git add <新規ファイル>
```

---

## 参考リンク

- [fff.nvim GitHub](https://github.com/dmtrKovalenko/fff.nvim)
- [snacks.nvim GitHub](https://github.com/folke/snacks.nvim)
- [lazy.nvim GitHub](https://github.com/folke/lazy.nvim)
