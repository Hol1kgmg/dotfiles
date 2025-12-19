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
        transparent = false, -- 背景を透過しない
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
