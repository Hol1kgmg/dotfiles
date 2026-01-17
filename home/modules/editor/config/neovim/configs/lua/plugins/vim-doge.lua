-- 関数説明プラグイン
-- Docs: https://github.com/kkoomen/vim-doge
return {
  'kkoomen/vim-doge',
  lazy = false,
  keys = {
    { "<leader>md", "<cmd>DogeGenerate<cr>", desc = "Generate doc" },
  },
  init = function()
    vim.g.doge_enable_mappings = 0  -- デフォルトの<leader>dを無効化
  end,
  config = function()
    vim.cmd([[call doge#install()]])
  end
}
