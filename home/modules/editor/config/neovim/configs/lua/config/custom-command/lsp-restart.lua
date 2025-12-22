-- :LspRestart - LSP再起動コマンド

vim.api.nvim_create_user_command("LspRestart", function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })

  if #clients == 0 then
    vim.notify("No LSP clients attached to current buffer", vim.log.levels.WARN)
    return
  end

  for _, client in ipairs(clients) do
    vim.notify(string.format("Restarting LSP client: %s", client.name), vim.log.levels.INFO)
    vim.lsp.stop_client(client.id)
    vim.defer_fn(function()
      vim.lsp.enable(client.name)
    end, 500)
  end
end, {})
