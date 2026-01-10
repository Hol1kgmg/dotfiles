-- :LspInfo - LSP情報表示コマンド

local float_window = require("config.utils.float-window")

-- 設定済みLSPサーバーリストをlsp.luaから取得
local lsp_config = require("config.lsp")
local configured_servers = lsp_config.servers

-- ヘッダー生成
local function build_header()
  return {
    "LSP Information",
    string.rep("=", 60),
    "",
  }
end

-- 現在のバッファのクライアント情報生成
local function build_current_clients(clients)
  local lines = { "Clients attached to current buffer:" }

  if #clients == 0 then
    table.insert(lines, "  (none)")
  else
    for _, client in ipairs(clients) do
      table.insert(lines, string.format("  • %s (id: %d)", client.name, client.id))
      table.insert(lines, string.format("    - root_dir: %s", client.root_dir or "unknown"))

      -- filetypesはvim.lsp.configから取得
      local config = vim.lsp.config[client.name]
      if config and config.filetypes then
        table.insert(lines, string.format("    - filetypes: %s", table.concat(config.filetypes, ", ")))
      end
    end
  end

  table.insert(lines, "")
  return lines
end

-- 全アクティブクライアント情報生成
local function build_all_clients(all_clients)
  local lines = { "All active LSP clients:" }

  if #all_clients == 0 then
    table.insert(lines, "  (none)")
  else
    local active_servers = {}
    for _, client in ipairs(all_clients) do
      active_servers[client.name] = true
      table.insert(lines, string.format("  • %s (id: %d)", client.name, client.id))
    end

    table.insert(lines, "")
    table.insert(lines, "Configured LSP servers:")
    for _, server_name in ipairs(configured_servers) do
      local status = active_servers[server_name] and "✓ active" or "○ configured"
      table.insert(lines, string.format("  • %s: %s", server_name, status))
    end
  end

  table.insert(lines, "")
  return lines
end

-- フッター生成
local function build_footer()
  return {
    string.rep("-", 60),
    "Commands:",
    "  :LspInfo     - Show this information",
    "  :LspRestart  - Restart LSP clients for current buffer",
    "  :checkhealth vim.lsp - Run LSP health check",
  }
end

-- コマンド定義
vim.api.nvim_create_user_command("LspInfo", function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  local all_clients = vim.lsp.get_clients()

  local lines = {}
  vim.list_extend(lines, build_header())
  vim.list_extend(lines, build_current_clients(clients))
  vim.list_extend(lines, build_all_clients(all_clients))
  vim.list_extend(lines, build_footer())

  float_window.show(lines, { width = 70, filetype = "lspinfo" })
end, {})
