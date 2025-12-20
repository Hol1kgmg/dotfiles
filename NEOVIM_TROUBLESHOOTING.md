# Neovim トラブルシューティング

Neovim環境で問題が発生した際の対処法をまとめています。

---

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
