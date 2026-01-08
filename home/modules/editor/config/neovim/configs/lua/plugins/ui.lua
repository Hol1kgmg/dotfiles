-- UI・キーヘルプ
return {
  -- アイコン
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },

  -- buffer view
  {
    "echasnovski/mini.tabline",
    version = false,
    config = function()
      require("mini.tabline").setup()
    end,
  },

  -- キーバインドヘルプ（mini.clue）
  {
    "echasnovski/mini.clue",
    version = false,
    event = "VeryLazy",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        -- トリガー設定
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },
          -- g key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },
          -- d key
          { mode = "n", keys = "d" },
          { mode = "x", keys = "d" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },
          -- z key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        -- キーバインド説明
        clues = {
          -- グループラベルのみ定義（個別キーマップはkeymaps.luaのdescを自動参照）
          { mode = "n", keys = "<Leader>f", desc = "+Find" },
          { mode = "n", keys = "<Leader>l", desc = "+Lazy" },
          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "n", keys = "<Leader>c", desc = "+Coding Agent" },
          { mode = "n", keys = "<Leader>r", desc = "+Re-Action" },
          { mode = "n", keys = "<leader>m", desc = "+Make Action" },
          { mode = "n", keys = "<Leader>i", desc = "+Info-View" },
          { mode = "n", keys = "<Leader>d", desc = "+Diagnostics" },
          { mode = "n", keys = "<Leader>h", desc = "+Hunk" },

          -- gキーマップ（よく使うもののみ手動定義）
          -- LSP関連
          { mode = "n", keys = "gd",        desc = "go to definition" },
          { mode = "n", keys = "gr",        desc = "find references" },
          { mode = "n", keys = "gD",        desc = "go to declaration" },
          { mode = "n", keys = "gi",        desc = "go to implementation" },
          -- ファイル・URL操作
          { mode = "n", keys = "gf",        desc = "go to file" },
          { mode = "n", keys = "gx",        desc = "open URL" },
          -- 編集・検索操作
          { mode = "n", keys = "gcc",       desc = "toggle comment" },
          { mode = "n", keys = "gq",        desc = "format text" },
          { mode = "n", keys = "g*",        desc = "search word forward" },
          { mode = "n", keys = "g#",        desc = "search word backward" },


          -- デフォルトヘルプ
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          delay = 300, -- 300ミリ秒後に表示
        },
      })
    end,
  },

  -- QoL機能集（snacks.nvim）
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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
  },

  -- ダッシュボード
  -- Docs: https://github.com/goolord/alpha-nvim
  {
    "goolord/alpha-nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ASCIIアート読み込み
      local ascii_art_path = vim.fn.stdpath("config") .. "/AA-dashboard.txt"
      if vim.fn.filereadable(ascii_art_path) == 1 then
        dashboard.section.header.val = vim.fn.readfile(ascii_art_path)
      else
        -- フォールバック用のシンプルなロゴ
        dashboard.section.header.val = {
          "                                                     ",
          "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
          "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
          "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
          "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
          "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
          "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
          "                                                     ",
        }
      end

      -- ボタン設定（Nerd Fonts）
      dashboard.section.buttons.val = {
        dashboard.button("f", "󰱼  Find file", ":lua require('fff').find_files()<CR>"),
        dashboard.button("n", "󰈔  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "󰋚  Recent files", ":lua Snacks.picker.recent()<CR>"),
        dashboard.button("g", "󱎸  Find text", ":lua Snacks.picker.grep()<CR>"),
        dashboard.button("c", "  Configuration", ":lua MiniFiles.open(vim.fn.stdpath('config') .. '/init.lua')<CR>"),
        dashboard.button("u", "󰚰  Update plugins", ":Lazy sync <CR>"),
        dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
      }

      -- alphaバッファでmini.clueのトリガーを有効化
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'alpha',
        callback = function()
          vim.schedule(function()
            require('mini.clue').ensure_buf_triggers()
          end)
        end
      })

      -- フッター設定
      local function footer()
        local total_plugins = require("lazy").stats().count
        local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch

        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
      end

      dashboard.section.footer.val = footer()

      -- レイアウト調整
      dashboard.section.header.opts.hl = "Type"
      dashboard.section.buttons.opts.hl = "Keyword"
      dashboard.section.footer.opts.hl = "Comment"

      -- 余白調整
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)
    end,
  },

  -- LSP診断・定義参照など
  {
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
  },

  -- ステータスライン
  -- Docs: https://github.com/nvim-lualine/lualine.nvim
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = { 'echasnovski/mini.icons', 'folke/trouble.nvim' },
    opts = function(_, opts)
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })

      opts.options = {
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      }
      opts.sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
          'filename',
          { symbols.get, cond = symbols.has },
        },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      }
    end,
  },
}
