-- ウィンドウ・バッファ操作キーマップ

local keymap = vim.keymap

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "to bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "to right window" })

-- バッファ移動
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "previous buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })

keymap.set("n", "<leader>bq", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("bd!")  -- ターミナルは強制削除
  else
    vim.cmd("bd")   -- 通常バッファは警告あり
  end
end, { desc = "quit buffer" })
