# Step 1: 基盤構築（Neovim + 基本設定 + lazy.nvim）

## 目的
Neovimの基盤となる環境を一括で構築する。
- Neovim本体のインストール
- 基本設定（options, keymaps）
- lazy.nvimのセットアップ

プラグインは導入せず、プラグインマネージャーが動作する状態まで確認する。

## 実装内容

### 1. ディレクトリ構造作成

```
home/modules/editor/config/neovim/
├── default.nix              # Nix設定（programs.neovim）
└── configs/                 # Lua設定ファイル群
    ├── init.lua             # エントリーポイント + lazy.nvim bootstrap
    └── lua/
        ├── config/
        │   ├── options.lua  # Neovim基本オプション設定
        │   └── keymaps.lua  # キーマッピング定義
        └── plugins/
            └── init.lua     # プラグイン定義（このステップでは空）
```

### 2. default.nix実装

**ファイル**: `home/modules/editor/config/neovim/default.nix`

```nix
{ pkgs, ... }:

{
  # Neovim基本設定
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # $EDITOR環境変数を設定
    viAlias = true;        # vi コマンドでneovimを起動
    vimAlias = true;       # vim コマンドでneovimを起動
  };

  # Lua設定ファイルを配置
  xdg.configFile."nvim".source = ./configs;
}
```

**説明**:
- `enable = true`: Neovimをインストール
- `defaultEditor = true`: `$EDITOR=nvim` を設定
- `viAlias`, `vimAlias`: エイリアス設定
- `xdg.configFile."nvim".source`: Lua設定ファイルを `~/.config/nvim/` に配置

### 3. init.lua実装

**ファイル**: `home/modules/editor/config/neovim/configs/init.lua`

```lua
-- Leader keyを設定（他の設定より先に）
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- 基本設定読み込み
require("config.options")
require("config.keymaps")

-- プラグイン設定読み込み
require("plugins")
```

**説明**:
- Leader keyを `<Space>` に設定
- lazy.nvimを自動インストール（初回起動時）
- 設定ファイルを順次読み込み

### 4. options.lua実装

**ファイル**: `home/modules/editor/config/neovim/configs/lua/config/options.lua`

```lua
local opt = vim.opt

-- 行番号
opt.number = true          -- 行番号表示
opt.relativenumber = true  -- 相対行番号

-- インデント
opt.tabstop = 2           -- タブ幅
opt.shiftwidth = 2        -- インデント幅
opt.expandtab = true      -- タブをスペースに変換
opt.smartindent = true    -- スマートインデント

-- 検索
opt.ignorecase = true     -- 大文字小文字を区別しない
opt.smartcase = true      -- 大文字が含まれる場合は区別する
opt.hlsearch = true       -- 検索結果をハイライト

-- UI
opt.termguicolors = true  -- True colorサポート
opt.signcolumn = "yes"    -- サインカラムを常に表示
opt.cursorline = true     -- カーソル行をハイライト
opt.wrap = false          -- 行の折り返しを無効化

-- ファイル
opt.swapfile = false      -- スワップファイルを作成しない
opt.backup = false        -- バックアップファイルを作成しない
opt.undofile = true       -- undoファイルを作成

-- スクロール
opt.scrolloff = 8         -- スクロール時の余白
opt.sidescrolloff = 8

-- その他
opt.clipboard = "unnamedplus"  -- システムクリップボードを使用
opt.mouse = "a"                -- マウスサポート
```

**説明**:
- 実用的な基本設定を定義
- 行番号、インデント、検索、UI等を設定

### 5. keymaps.lua実装

**ファイル**: `home/modules/editor/config/neovim/configs/lua/config/keymaps.lua`

```lua
local keymap = vim.keymap

-- 基本操作
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "保存" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "終了" })
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "全て終了（保存なし）" })

-- 検索ハイライトをクリア
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

-- バッファ移動
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "前のバッファ" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "次のバッファ" })

-- インデント調整（ビジュアルモード）
keymap.set("v", "<", "<gv", { desc = "インデントを減らす" })
keymap.set("v", ">", ">gv", { desc = "インデントを増やす" })

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "行を下に移動" })
keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "行を上に移動" })
```

**説明**:
- Leader keyベースの基本操作
- ウィンドウ・バッファ移動
- ビジュアルモードでの編集操作

### 6. plugins/init.lua実装

**ファイル**: `home/modules/editor/config/neovim/configs/lua/plugins/init.lua`

```lua
-- lazy.nvim設定
require("lazy").setup({
  -- このステップではプラグインなし
  -- 次のステップからプラグインを追加していく
}, {
  -- lazy.nvimのオプション設定
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = false,  -- 自動更新チェックを無効化
  },
})
```

**説明**:
- 空のプラグインリストでlazy.nvimを初期化
- UIをシンプルに設定

### 7. home/modules/editor/default.nixに統合

**ファイル**: `home/modules/editor/default.nix`

既存:
```nix
{
  imports = [
    ./config/vscode
    # 将来的にneovim等を追加
    # ./config/neovim
  ];
}
```

変更後:
```nix
{
  imports = [
    ./config/vscode
    ./config/neovim
  ];
}
```

## 動作確認手順

### 1. Rebuild実行
```bash
cd ~/dotfiles
darwin-rebuild switch --flake .
```

### 2. バージョン確認
```bash
nvim --version
```
**期待される出力**: `NVIM v0.x.x`

### 3. Neovim起動
```bash
nvim
```

**確認項目**:
- エラーなく起動する
- lazy.nvimが自動インストールされる（初回のみ）

### 4. 基本設定確認

Neovim内で以下を確認:
```vim
:set number?          " -> number (行番号が表示されているか)
:set tabstop?         " -> tabstop=2
:set expandtab?       " -> expandtab
```

### 5. lazy.nvim動作確認
```vim
:Lazy
```
**期待される結果**: lazy.nvimのUIが開く（プラグイン0個）

### 6. キーマップ確認
- `<Space>w` で保存（`:w`と同じ）
- `<Space>q` で終了（`:q`と同じ）
- `<Esc>` で検索ハイライトクリア

### 7. エイリアス確認
```bash
vi --version   # nvimが起動
vim --version  # nvimが起動
echo $EDITOR   # -> nvim
```

## トラブルシューティング

### エラー: "module 'config.options' not found"
→ ファイルパスが正しいか確認
→ `configs/lua/config/options.lua` が存在するか確認

### lazy.nvimがインストールされない
→ git がインストールされているか確認: `which git`
→ ネットワーク接続を確認

### 設定が反映されない
→ 設定ファイルが `~/.config/nvim/` に配置されているか確認
→ `ls -la ~/.config/nvim/`

## 完了条件

- ✅ ディレクトリ構造が作成されている
- ✅ 全てのファイルが実装されている
- ✅ `darwin-rebuild switch` が成功
- ✅ `nvim --version` でバージョン表示
- ✅ Neovimがエラーなく起動
- ✅ 基本設定（行番号、タブ幅等）が動作
- ✅ `:Lazy` コマンドが使える
- ✅ 基本キーマップが動作
- ✅ vi/vimエイリアスが機能
- ✅ `$EDITOR` 環境変数が設定されている

## 次のステップ

Step 1完了後:
1. このドキュメント（`neovim-step1-foundation-plan.md`）を削除
2. Step 2用のドキュメント（`neovim-step2-colorscheme-plan.md`）を作成
3. カラースキームのプラグイン選定・実装
