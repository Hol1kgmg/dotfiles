-- 関数説明プラグイン
-- Docs: https://github.com/kkoomen/vim-doge
-- Keymaps: keymaps/init.lua (<leader>md)
return {
  'kkoomen/vim-doge',
  lazy = false,
  init = function()
    vim.g.doge_enable_mappings = 0  -- デフォルトの<leader>dを無効化
  end,
  config = function()
    vim.cmd([[call doge#install()]])
  end
}
