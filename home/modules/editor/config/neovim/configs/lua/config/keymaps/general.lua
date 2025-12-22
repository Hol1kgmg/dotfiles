-- 一般的なキーマップ

local keymap = vim.keymap

-- 基本操作
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "save" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "quit" })
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "quit(not save)" })

-- Lazy.nvim
keymap.set("n", "<leader>Ll", "<cmd>Lazy<cr>", { desc = "open Lazy.nvim"})
keymap.set("n", "<leader>Lu", "<cmd>Lazy update<cr>", { desc = "open Lazy update"})

-- 検索ハイライトをクリア
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "to bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "to right window" })

-- バッファ移動
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "previous buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })

keymap.set("n", "<leader>bq", "<cmd>bd<cr>", { desc = "quit buffer" })

-- インデント調整（ビジュアルモード）
keymap.set("v", "<", "<gv", { desc = "Reduce indentation" })
keymap.set("v", ">", ">gv", { desc = "Increase indent" })

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "行を下に移動" })
keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "行を上に移動" })

-- ファイラー（mini.files）
keymap.set("n", "<leader>e", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "open filer (this file)" })

keymap.set("n", "<leader>E", function()
  require("mini.files").open()
end, { desc = "open filer (cwd)" })

-- Fuzzy Finder（fff.nvim）
keymap.set("n", "<leader>ff", "<cmd>FFFFind<CR>", { desc = "fzf" })
keymap.set("n", "<leader><leader>", "<cmd>FFFFind<CR>", { desc = "fzf" })
keymap.set("n", "<leader>fh", "<cmd>FFFHealth<CR>", { desc = "FFF health check" })

-- snacks.picker
keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "buffer list" })


-- snacks.nvim（ターミナル・Git）
keymap.set("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "LazyGit" })

keymap.set("n", "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git open browser" })

keymap.set("n", "<leader>t", function()
  Snacks.terminal()
end, { desc = "open terminal" })
