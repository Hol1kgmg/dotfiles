-- AI操作キーマップ

local keymap = vim.keymap

-- Claude Code
keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "toggle Claude Code" })
keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", { desc = "focus Claude Code" })
keymap.set("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "select Model Claude Code" })
keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "send selection to Claude" })
keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "accept Claude diff" })
keymap.set("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "deny Claude diff" })

