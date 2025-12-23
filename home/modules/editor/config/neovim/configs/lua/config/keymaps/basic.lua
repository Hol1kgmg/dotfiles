-- 基本操作キーマップ

local keymap = vim.keymap

-- 基本操作
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "save" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "quit" })
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "quit(not save)" })
keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "exit terminal mode"})

-- 検索ハイライトをクリア
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Lazy.nvim
keymap.set("n", "<leader>Ll", "<cmd>Lazy<cr>", { desc = "open Lazy.nvim"})
keymap.set("n", "<leader>Lu", "<cmd>Lazy update<cr>", { desc = "open Lazy update"})
