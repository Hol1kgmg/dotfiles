-- LSP診断・定義参照など
return {
  "folke/trouble.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "de", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
    { "dr", "<cmd>Trouble lsp_references toggle<cr>", desc = "References" },
    { "di", "<cmd>Trouble lsp_implementations toggle<cr>", desc = "Implementation" },
    { "dE", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "Definition" },
    { "dt", "<cmd>Trouble lsp_type_definitions toggle<cr>", desc = "Type Definitions" },
    { "ds", "<cmd>Trouble symbols toggle<cr>", desc = "Document Symbols" },
    { "dc", "<cmd>Trouble lsp_incoming_calls toggle<cr>", desc = "Incoming Calls" },
    { "dC", "<cmd>Trouble lsp_outgoing_calls toggle<cr>", desc = "Outgoing Calls" },
  },
  opts = function()
    -- 共通のfloatウィンドウ設定
    local shared_float_win = {
      type = "float",
      focus = true,
      relative = "editor",
      border = "single",
      title = "Trouble.nvim",
      title_pos = "center",
      position = { 0, -2 },
      size = { width = 0.3, height = 0.3 },
      zindex = 200,
    }

    return {
      focus = true,
      keys = {
        ["<cr>"] = "jump_close",
        ["<esc>"] = "close"
      },
      win = shared_float_win,

      modes = {
        symbols = {
          focus = true,
          win = shared_float_win,
        }
      }
    }
  end,
  cmd = "Trouble",
}
