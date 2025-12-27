-- 情報表示キーマップ

local keymap = vim.keymap

-- Health check
keymap.set("n", "<leader>ih", "<cmd>HealthCheck<cr>", { desc = "health check (save to /tmp)" })
