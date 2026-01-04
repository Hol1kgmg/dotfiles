-- AI操作キーマップ

local keymap = vim.keymap

-- Copilot トグル機能
local copilot_enabled = false

local function toggle_copilot()
  if copilot_enabled then
    -- Copilot を停止
    vim.cmd("Copilot disable")
    vim.cmd("Copilot stop")
    copilot_enabled = false
    vim.notify("Copilot: OFF", vim.log.levels.INFO)
  else
    -- Copilot を起動
    vim.cmd("Copilot auth")
    vim.cmd("Copilot enable")
    copilot_enabled = true
    vim.notify("Copilot: ON", vim.log.levels.INFO)
  end
end

-- Copilot
keymap.set("n", "<leader>co", toggle_copilot, { desc = "toggle Copilot on/off" })

-- Claude Code
keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "toggle Claude Code" })
keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", { desc = "focus Claude Code" })
keymap.set("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "select Model Claude Code" })
keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "send selection to Claude" })
keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "accept Claude diff" })
keymap.set("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "deny Claude diff" })

