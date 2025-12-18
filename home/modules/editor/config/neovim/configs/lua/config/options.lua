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
