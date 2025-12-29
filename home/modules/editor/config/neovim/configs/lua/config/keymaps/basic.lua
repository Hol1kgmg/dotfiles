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

-- ターミナル
keymap.set("n", "<leader>t", function()
  Snacks.terminal()
end, { desc = "open terminal (split)" })

-- バッファターミナルの連番カウンタ
local term_count = 0

keymap.set("n", "<leader>T", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  local bufnr = vim.api.nvim_get_current_buf()
  term_count = term_count + 1
  vim.api.nvim_buf_set_name(bufnr, "Terminal " .. term_count)
  vim.cmd("startinsert")
end, { desc = "open terminal (buffer)" })


