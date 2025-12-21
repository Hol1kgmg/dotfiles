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
}
