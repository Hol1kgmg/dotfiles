-- エディタ機能
return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    opts = {
      -- インストールする言語パーサー
      ensure_installed = {
        "typescript",
        "tsx",
        "html",
        "python",
        "yaml",
        "toml",
        "json",
        "vim",
        "lua",
        "markdown",
        "nix",
      },
      -- シンタックスハイライト
      highlight = {
        enable = true,
      },
      -- インデント
      indent = {
        enable = true,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- 入力補完
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      check_ts = true,
    },
  },

  -- 補完エンジン
  -- Docs: https://cmp.saghen.dev/
  -- Note: buildフィールドを削除し、GitHubリリース版のプリビルドバイナリを使用
  {
    'saghen/blink.cmp',
    version = 'v0.*',
    event = { "InsertEnter", "CmdLineEnter" },
    opts = {
      -- キーマップ設定（デフォルト使用）
      -- カスタマイズ方法: https://cmp.saghen.dev/configuration/keymap.html#default
      keymap = { preset = 'super-tab' },

      -- 外観設定
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      -- 補完ソース設定
      sources = {
        default = { "snippets", "lsp", "path", "buffer" },
        per_filetype = {
          markdown = { "snippets", "lsp", "path" },
          mdx = { "snippets", "lsp", "path" },
        },
      },

      -- スニペット設定
      snippets = { preset = "luasnip" },

      -- 補完動作設定
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = {
          enabled = true,
        },
      },

      -- シグネチャヘルプ
      signature = {
        enabled = true,
      },
    },
  },

  -- スニペットエンジン
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = {
      "rafamadriz/friendly-snippets", -- VSCodeスニペットコレクション
    },
    config = function()
      local luasnip = require("luasnip")

      -- VSCodeスニペット読み込み（friendly-snippets）
      require("luasnip.loaders.from_vscode").lazy_load()

      -- カスタムスニペット読み込み（Luaファイル）
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/snippets" }
      })

      -- 基本設定
      luasnip.config.setup({
        history = true, -- スニペット履歴
        updateevents = "TextChanged,TextChangedI", -- リアルタイム更新
      })
    end,
  },
}
