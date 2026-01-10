-- GitHub Copilot
-- Docs: https://github.com/zbirenbaum/copilot.lua
-- Note: デフォルトでは起動しない。<leader>coで手動切り替え
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  opts = {
    suggestion = {
      enabled = false,  -- blink.cmp経由で使用するため無効化
      auto_trigger = false,
    },
    panel = {
      enabled = false,  -- パネルUIは無効化
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
    },
  },
}
