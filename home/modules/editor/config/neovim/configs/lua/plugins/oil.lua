-- ファイラー
-- Keymaps: lua/config/keymaps/plugins/oil.lua
return {
  "stevearc/oil.nvim",
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    local oil_keymaps = require("config.keymaps.plugins.oil")

    require("oil").setup({
      is_hidden_file = function(name)
        return name:match("^%.")
          or name == "DS_Store"
          or name == "Thumbs.db"
          or name:match("%.swp$")
          or name:match("~$")
      end,

      lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
      },

      use_default_keymaps = false,
      keymaps = oil_keymaps.keymaps,

      float = {
        padding = 1,
        max_width = 0.9,
        max_height = 0.9,
        border = "single",
        preview_split = "right",
        get_win_title = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local root = vim.fn.getcwd()
          local relpath = "."
          if cwd ~= root and cwd:find(root, 1, true) == 1 then
            relpath = cwd:sub(#root + 2)
          elseif cwd ~= root then
            relpath = cwd
          end
          return "[OIL] " .. relpath
        end,
      },
    })

    -- バッファ固有キーマップ
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function(args)
        oil_keymaps.setup_buffer_keymaps(args.buf)
      end,
    })
  end,
}
