-- ファイル操作・検索
return {
  -- ファイラー
  {
    "echasnovski/mini.files",
    version = false,
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("mini.files").setup({
        -- カスタマイズオプション
        mappings = {
          go_in = "<Tab>",
          go_out = "<S-Tab>",
        },
        options = {
          use_as_default_explorer = true,
        },
        windows = {
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 50,
        },
      })
    end,
  },

  -- Fuzzy Finder（fff.nvim）
  {
    "dmtrKovalenko/fff.nvim",
    lazy = false,  -- プラグイン自身が遅延読み込みを実装
    dependencies = {
      "folke/snacks.nvim",  -- 画像プレビュー用
    },
    build = ":lua require('fff.download').download_or_build_binary()",
    opts = {
      default_file_explorer = false,  -- mini.filesを優先
      debug = {
        enabled = true,      -- ベータ版のため協力が推奨される
        show_scores = true,  -- スコアリングシステム最適化のため
      },
    },
  },
}
