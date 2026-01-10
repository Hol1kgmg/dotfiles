-- Git差分表示
-- Docs: https://github.com/lewis6991/gitsigns.nvim
-- キーマップ: lua/config/keymaps/git.lua で管理
return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = '│' },
      change       = { text = '│' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    on_attach = function(bufnr)
      require('config.keymaps.git').setup_gitsigns_keymaps(bufnr)
    end
  },
}
