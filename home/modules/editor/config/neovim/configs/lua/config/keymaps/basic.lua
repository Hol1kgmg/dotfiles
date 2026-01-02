-- 基本操作キーマップ

local keymap = vim.keymap

-- 基本操作
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "save" })
keymap.set("n", "<leader>Q", "<cmd>q<cr>", { desc = "quit" })
keymap.set("n", "<leader>FQ", "<cmd>qa!<cr>", { desc = "force quit(not save)" })
keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "exit terminal mode"})

-- 検索ハイライトをクリア
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Lazy.nvim
keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "open Lazy.nvim"})
keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "open Lazy update"})

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

-- lazydocker
keymap.set("n", "<leader>ld", function()
  Snacks.terminal("lazydocker", { win = { position = "float" } })
end, { desc = "open lazydocker" })


