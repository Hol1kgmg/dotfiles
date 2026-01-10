-- oil.nvim バッファ内キーマップ
-- plugins/oil.lua から参照される

local M = {}

-- oil.setup({ keymaps = ... }) に渡すテーブル
M.keymaps = {
  ["g?"] = { "actions.show_help", mode = "n" },
  ["."] = { "actions.toggle_hidden", mode = "n" },
  ["L"] = { "actions.select", mode = "n" },
  ["H"] = { "actions.parent", mode = "n" },
  ["<Tab>"] = { "actions.select", mode = "n" },
  ["<S-Tab>"] = { "actions.parent", mode = "n" },
  ["<C-t>"] = { "actions.select", opts = { tab = true } },
  ["<C-p>"] = { "actions.preview", mode = "n" },
  ["q"] = { "actions.close", mode = "n" },
  ["<C-r>"] = "actions.refresh",
  ["pwd"] = { "actions.open_cwd", mode = "n" },
  ["cd"] = { "actions.cd", mode = "n" },
  ["tcd"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
}

-- バッファ固有のキーマップ設定（autocmd用）
M.setup_buffer_keymaps = function(bufnr)
  vim.keymap.set("n", "J", "j", { buffer = bufnr, desc = "move down" })
  vim.keymap.set("n", "K", "k", { buffer = bufnr, desc = "move up" })
end

return M
