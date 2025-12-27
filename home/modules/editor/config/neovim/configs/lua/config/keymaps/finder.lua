-- ファイル検索・探索キーマップ

local keymap = vim.keymap

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
keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "live grep" })
