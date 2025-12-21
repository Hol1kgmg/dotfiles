-- UI・キーヘルプ
return {
  -- アイコン
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- buffer view
  {
    "echasnovski/mini.tabline",
    version = false,
    config = function()
      require("mini.tabline").setup()
    end,
  },

  -- キーバインドヘルプ（mini.clue）
  {
    "echasnovski/mini.clue",
    version = false,
    event = "VeryLazy",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        -- トリガー設定
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          -- g key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          -- Window commands
          { mode = "n", keys = "<C-w>" },
          -- z key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        -- キーバインド説明
        clues = {
          -- グループラベルのみ定義（個別キーマップはkeymaps.luaのdescを自動参照）
          { mode = "n", keys = "<Leader>f", desc = "+Find" },
          { mode = "n", keys = "<Leader>L", desc = "+Lazy.nvim" },
          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "n", keys = "<leader>b", desc = "+Buffer"},

          -- デフォルトヘルプ
          miniclue.gen_clues.g(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          delay = 300,  -- 300ミリ秒後に表示
        },
      })
    end,
  },

  -- QoL機能集（snacks.nvim）
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- 必須機能
      notifier = { enabled = true },
      terminal = { enabled = true },
      picker = { enabled = true },  -- バッファピッカー
      dashboard = { enabled = true },  -- ダッシュボード

      -- Git統合
      lazygit = { enabled = true },
      gitbrowse = { enabled = true },

      -- オプション機能
      bigfile = { enabled = true },  -- 大規模ファイル対応
      scroll = { enabled = false },
      indent = { enabled = false },
    },
  },
}
