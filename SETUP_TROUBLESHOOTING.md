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

## 参考リンク

- [fff.nvim GitHub](https://github.com/dmtrKovalenko/fff.nvim)
- [snacks.nvim GitHub](https://github.com/folke/snacks.nvim)
- [lazy.nvim GitHub](https://github.com/folke/lazy.nvim)
