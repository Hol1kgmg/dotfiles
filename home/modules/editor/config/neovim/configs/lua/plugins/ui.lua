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
          { mode = "n", keys = "<Leader>L", desc = "+Lazy.nvim" },
          { mode = "n", keys = "<Leader>g", desc = "+Git" },
          { mode = "n", keys = "<Leader>c", desc = "+Claude Code" },
          { mode = "n", keys = "<leader>b", desc = "+Buffer" },
          { mode = "n", keys = "<leader>r", desc = "+Re-Action" },
          { mode = "n", keys = "<leader>i", desc = "+Info-View" },
          { mode = "n", keys = "<leader>h", desc = "+Hunk" },

          -- gキーマップ（よく使うもののみ手動定義）
          -- LSP関連
          { mode = "n", keys = "gd", desc = "go to definition" },
          { mode = "n", keys = "gr", desc = "find references" },
          { mode = "n", keys = "gD", desc = "go to declaration" },
          { mode = "n", keys = "gi", desc = "go to implementation" },
          -- ファイル・URL操作
          { mode = "n", keys = "gf", desc = "go to file" },
          { mode = "n", keys = "gx", desc = "open URL" },
          -- 編集・検索操作
          { mode = "n", keys = "gcc", desc = "toggle comment" },
          { mode = "n", keys = "gq", desc = "format text" },
          { mode = "n", keys = "g*", desc = "search word forward" },
          { mode = "n", keys = "g#", desc = "search word backward" },

          -- デフォルトヘルプ
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          delay = 300,  -- 300ミリ秒後に表示
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
      picker = { enabled = true },  -- バッファピッカー
      dashboard = { enabled = false },

      -- Git統合
      lazygit = { enabled = true },
      gitbrowse = { enabled = true },

      -- オプション機能
      bigfile = { enabled = true },  -- 大規模ファイル対応
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
        dashboard.button("g", "󱎸  Find text", ":lua require('fff').grep()<CR>"),
        dashboard.button("c", "  Configuration", ":lua MiniFiles.open(vim.fn.expand('~/dotfiles/home/modules/editor/config/neovim/configs/init.lua'))<CR>"),
        dashboard.button("u", "󰚰  Update plugins", ":Lazy sync <CR>"),
        dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
      }

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

  -- ステータスライン
  -- Docs: https://github.com/nvim-lualine/lualine.nvim
  {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    dependencies = { 'echasnovski/mini.icons' },
    opts = {
      options = {
        theme = 'auto',
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
    },
  },
}
