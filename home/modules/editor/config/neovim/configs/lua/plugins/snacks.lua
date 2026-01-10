-- QoL機能集（snacks.nvim）
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- 必須機能
    notifier = { enabled = true },
    terminal = { enabled = true },
    picker = { enabled = true }, -- バッファピッカー
    dashboard = { enabled = false },

    -- Git統合
    lazygit = { enabled = true },
    gitbrowse = { enabled = true },

    -- オプション機能
    bigfile = { enabled = true }, -- 大規模ファイル対応
    zen = {
      enabled = true,
    },
    scroll = { enabled = false },
    indent = { enabled = false },
  },
}
