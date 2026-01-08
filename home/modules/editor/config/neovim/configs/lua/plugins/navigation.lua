-- ファイル操作・検索
return {
  -- ファイラー
  -- {
  --   "echasnovski/mini.files",
  --   version = false,
  --   dependencies = { "echasnovski/mini.icons" },
  --   config = function()
  --     require("mini.files").setup({
  --       -- カスタマイズオプション
  --       mappings = {
  --         go_in = '',  -- lを無効化してカーソル移動として使用
  --         go_out = '', -- hを無効化してカーソル移動として使用
  --       },
  --       options = {
  --         use_as_default_explorer = true,
  --       },
  --       windows = {
  --         preview = true,
  --         width_focus = 30,
  --         width_nofocus = 15,
  --         width_preview = 50,
  --       },
  --     })
  --   end,
  -- },
  {
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
  },

  -- Fuzzy Finder（fff.nvim）
  {
    "dmtrKovalenko/fff.nvim",
    lazy = false,  -- プラグイン自身が遅延読み込みを実装
    dependencies = {
      "folke/snacks.nvim",  -- 画像プレビュー用
    },
    build = ":lua require('fff.download').download_or_build_binary()",
    opts = {
      default_file_explorer = false,  -- mini.filesを優先
      debug = {
        enabled = true,      -- ベータ版のため協力が推奨される
        show_scores = true,  -- スコアリングシステム最適化のため
      },
    },
  },
}
