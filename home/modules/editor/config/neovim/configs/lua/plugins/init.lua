-- lazy.nvim設定
require("lazy").setup({
  -- このステップではプラグインなし
  -- 次のステップからプラグインを追加していく
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
