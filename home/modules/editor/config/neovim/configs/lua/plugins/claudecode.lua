-- Claude Code 統合
return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "toggle Claude Code" },
    { "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", desc = "focus Claude Code" },
    { "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", desc = "select Model Claude Code" },
    { "<leader>cs", "<cmd>ClaudeCodeSend<CR>", mode = "v", desc = "send selection to Claude" },
    { "<leader>cA", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "accept Claude diff" },
    { "<leader>cD", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "deny Claude diff" },
  },
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
}
