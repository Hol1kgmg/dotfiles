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

  -- blink.cmpはあとで実装
  -- {
  --   'saghen/blink.cmp',
  --   event = { "InsertEnter", "CmdLineEnter" },
  --   build = 'nix run .#build-plugin',
  --   opts = {
  --     sources = {
  --       default = { "snippets", "lsp", "path", "buffer" },
  --       per_filetype = {
  --         markdown = { "snippets", "lsp", "path" },
  --         mdx = { "snippets", "lsp", "path" },
  --       },
  --     },
  --   },
  -- },
}
