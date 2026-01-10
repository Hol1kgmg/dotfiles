-- 関数説明プラグイン
-- Docs: https://github.com/kkoomen/vim-doge
return {
  'kkoomen/vim-doge',
  lazy = false,
  config = function()
    vim.cmd([[call doge#install()]])
  end
}
