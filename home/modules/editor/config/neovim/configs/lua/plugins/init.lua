-- lazy.nvim設定
require("lazy").setup({
  -- カラースキーム
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- カラースキームは最優先で読み込む
    config = function()
      require("kanagawa").setup({
        compile = false, -- コンパイル機能を無効化（高速化）
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true, -- 背景を透過する
        dimInactive = false, -- 非アクティブウィンドウを暗くしない
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none", -- 行番号背景を透明に
              },
            },
          },
        },
      })
      -- カラースキームを適用
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },

  -- アイコン
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },

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

  -- QoL機能集（snacks.nvim）
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- 必須機能
      notifier = { enabled = true },
      terminal = { enabled = true },

      -- Git統合
      lazygit = { enabled = true },
      gitbrowse = { enabled = true },

      -- オプション機能
      bigfile = { enabled = true },  -- 大規模ファイル対応
      scroll = { enabled = false },
      indent = { enabled = false },
    },
  },

  -- ファジーファインダー（fff.nvim）
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
}, {
  -- lazy.nvimのオプション設定
  ui = {
    border = "rounded",
  },
  checker = {
    enabled = false,  -- 自動更新チェックを無効化
  },
  rocks = {
    enabled = false,  -- rocks機能を無効化（不要なため）
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  -- lockfileをデータディレクトリに配置（Nix管理下の設定ディレクトリは読み取り専用のため）
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
})
