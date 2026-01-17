-- QoL機能集（snacks.nvim）
---@diagnostic disable: undefined-global

-- バッファターミナルの連番カウンタ
local term_count = 0

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    -- ターミナル
    { "<leader>t", function() Snacks.terminal() end, desc = "open terminal (split)" },
    { "<leader>T", function()
      vim.cmd("enew")
      vim.cmd("terminal")
      local bufnr = vim.api.nvim_get_current_buf()
      term_count = term_count + 1
      vim.api.nvim_buf_set_name(bufnr, "Terminal " .. term_count)
      vim.cmd("startinsert")
    end, desc = "open terminal (buffer)" },
    { "<leader>ld", function() Snacks.terminal("lazydocker", { win = { position = "float" } }) end, desc = "open lazydocker" },

    -- Zenモード
    { "<leader>z", function() Snacks.zen() end, desc = "toggle zen mode" },

    -- Picker
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "buffer list" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "live grep" },

    -- Git
    { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
  },
  opts = {
    -- 必須機能
    notifier = { enabled = true },
    terminal = { enabled = true },
    picker = { enabled = true }, -- バッファピッカー
    dashboard = { enabled = false },

    -- Git統合
    lazygit = { enabled = true },
    gitbrowse = { enabled = true },

    -- オプション機能
    bigfile = { enabled = true }, -- 大規模ファイル対応
    zen = {
      enabled = true,
    },
    scroll = { enabled = false },
    indent = { enabled = false },
  },
}
