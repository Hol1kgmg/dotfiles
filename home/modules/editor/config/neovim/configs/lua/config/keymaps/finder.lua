-- ファイル検索・探索キーマップ

local keymap = vim.keymap

-- -- ファイラー（mini.files）
-- keymap.set("n", "<leader>e", function()
--   require("mini.files").open(vim.api.nvim_buf_get_name(0))
-- end, { desc = "open filer (this file)" })
--
-- keymap.set("n", "<leader>E", function()
--   require("mini.files").open()
-- end, { desc = "open filer (cwd)" })
--
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'MiniFilesBufferCreate',
--   callback = function(args)
--     local buf_id = args.data.buf_id
--     local MiniFiles = require('mini.files')
--
--     keymap.set('n', 'J', 'j', { buffer = buf_id, desc = "Move down" })
--     keymap.set('n', 'K', 'k', { buffer = buf_id, desc = "Move up" })
--
--     keymap.set('n', '<Tab>', MiniFiles.go_in, { buffer = buf_id, desc = "Go in (enter dir)" })
--     keymap.set('n', '<S-Tab>', MiniFiles.go_out, { buffer = buf_id, desc = "Go out (parent dir)" })
--   end,
-- })

-- ファイラー(oil.nvim)
keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "open filer(this files)"})
keymap.set("n", "<leader>E", "<cmd>Oil . --float<cr>", { desc = "open filer (cwd)" })

-- Fuzzy Finder（fff.nvim）
keymap.set("n", "<leader>ff", "<cmd>FFFFind<CR>", { desc = "fzf" })
keymap.set("n", "<leader><leader>", "<cmd>FFFFind<CR>", { desc = "fzf" })
keymap.set("n", "<leader>fh", "<cmd>FFFHealth<CR>", { desc = "FFF health check" })

-- snacks.picker
keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "buffer list" })
keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "live grep" })
