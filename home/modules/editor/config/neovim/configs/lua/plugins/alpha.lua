-- ダッシュボード
-- Docs: https://github.com/goolord/alpha-nvim
return {
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

    dashboard.section.buttons.val = {
      dashboard.button("f", "󰱼  Find file", ":lua require('fff').find_files()<CR>"),
      dashboard.button("n", "󰈔  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "󰋚  Recent files", ":lua Snacks.picker.recent()<CR>"),
      dashboard.button("g", "󱎸  Find text", ":lua Snacks.picker.grep()<CR>"),
      dashboard.button("c", "󱁻  Configuration", ":lua MiniFiles.open(vim.fn.stdpath('config') .. '/init.lua')<CR>"),
      dashboard.button("u", "󰚰  Update plugins", ":Lazy sync <CR>"),
      dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
    }

    local function is_empty_buffer()
      return vim.bo.buftype == ""
        and vim.fn.expand("%") == ""
        and vim.fn.line("$") == 1
        and vim.fn.getline(1) == ""
    end

    local function show_alpha_if_empty()
      vim.schedule(function()
        if is_empty_buffer() then
          require("alpha").start()
        end
      end)
    end

    local augroup = vim.api.nvim_create_augroup("AlphaConfig", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = "alpha",
      callback = function()
        vim.schedule(function()
          require("mini.clue").ensure_buf_triggers()
        end)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = { "AlphaReady", "AlphaClosed" },
      callback = function(event)
        vim.opt.showtabline = event.match == "AlphaReady" and 0 or 2
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = "lazy",
      callback = function()
        vim.api.nvim_create_autocmd("BufWinLeave", {
          group = augroup,
          buffer = 0,
          once = true,
          callback = show_alpha_if_empty,
        })
      end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
      group = augroup,
      callback = function(event)
        local buftype = vim.bo[event.buf].buftype
        if buftype ~= "" then
          return
        end
        local listed_bufs = vim.fn.getbufinfo({ buflisted = 1 })
        if #listed_bufs <= 1 then
          show_alpha_if_empty()
        end
      end,
    })

    local function footer()
      local total_plugins = require("lazy").stats().count
      local datetime = os.date(" %Y-%m-%d   %H:%M:%S")
      local version = vim.version()
      local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
      return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
    end

    dashboard.section.footer.val = footer()
    dashboard.section.header.opts.hl = "Type"
    dashboard.section.buttons.opts.hl = "Keyword"
    dashboard.section.footer.opts.hl = "Comment"

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
}
