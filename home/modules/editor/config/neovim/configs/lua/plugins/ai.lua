-- AI統合機能
return {
  -- GitHub Copilot
  -- Docs: https://github.com/zbirenbaum/copilot.lua
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
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
  },

  -- Copilot blink.cmp統合
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = { "zbirenbaum/copilot.lua" },
  },

  -- Claude Code 統合
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info",

      -- Send/Focus Behavior
      focus_after_send = false,

      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- Terminal Configuration
      terminal = {
        split_side = "right",
        split_width_percentage = 0.30,
        provider = "snacks",
        auto_close = true,
        snacks_win_opts = {},
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = false,
      },
    },
  },
}
