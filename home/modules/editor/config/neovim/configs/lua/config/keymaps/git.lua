-- Git・ターミナルキーマップ

local keymap = vim.keymap

-- Git操作（snacks.nvim）
keymap.set("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "LazyGit" })

keymap.set("n", "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git open browser" })

-- ターミナル
keymap.set("n", "<leader>t", function()
  Snacks.terminal()
end, { desc = "open terminal" })
