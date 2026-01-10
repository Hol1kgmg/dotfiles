-- ファイラー
return {
  "stevearc/oil.nvim",
  dependencies = { "echasnovski/mini.icons" },
  config = function ()
    require("oil").setup({
      is_hidden_file = function (name)
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
      keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["."] = { "actions.toggle_hidden", mode = "n" },
        ["L"] = { "actions.select", mode = "n" },
        ["H"] = { "actions.parent", mode = "n" },
        ["<Tab>"] = { "actions.select", mode = "n" },
        ["<S-Tab>"] = { "actions.parent", mode = "n" },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = { "actions.preview", mode = "n" },
        ["q"] = { "actions.close", mode = "n" },
        ["<C-r>"] = "actions.refresh",
        ["pwd"] = { "actions.open_cwd", mode = "n" },
        ["cd"] = { "actions.cd", mode = "n" },
        ["tcd"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      },

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function (args)
          vim.keymap.set("n", "J", "j", { buffer = args.buf, desc = "move down"} )
          vim.keymap.set("n", "K", "k", { buffer = args.buf, desc = "move up"} )
        end,
      }),

      float = {
        padding = 1,
        max_width = 0.9,
        max_height = 0.9,
        border = "single",
        preview_split = "right",
        get_win_title = function ()
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
  end
}
