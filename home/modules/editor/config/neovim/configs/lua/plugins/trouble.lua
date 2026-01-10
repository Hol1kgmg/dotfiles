-- LSP診断・定義参照など
return {
  "folke/trouble.nvim",
  event = { "BufReadPre", "BufNewFile" },
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
