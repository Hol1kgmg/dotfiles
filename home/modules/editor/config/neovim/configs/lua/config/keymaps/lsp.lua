-- LSPキーマップ

local keymap = vim.keymap

-- LSP操作（LSP起動時のみ有効化）
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- ヘルパー関数（冗長性削減）
    local function map(mode, lhs, rhs, desc)
      keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- 定義・参照
    map("n", "gd", vim.lsp.buf.definition, "go to definition")
    map("n", "gr", vim.lsp.buf.references, "find references")
    map("n", "gD", vim.lsp.buf.declaration, "go to declaration")
    map("n", "gi", vim.lsp.buf.implementation, "go to implementation")

    -- ホバー・シグネチャヘルプ
    map("n", "K", vim.lsp.buf.hover, "hover documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "signature help")

    -- コード操作
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "rename")

    -- 診断
    map("n", "<leader>d", vim.diagnostic.open_float, "show diagnostic")
    map("n", "[d", vim.diagnostic.goto_prev, "previous diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "next diagnostic")
    map("n", "<leader>dl", vim.diagnostic.setloclist, "diagnostic list")

    -- フォーマット
    map("n", "<leader>fm", function()
      vim.lsp.buf.format({ async = true })
    end, "format")


  end,
})

-- LSP custom command
keymap.set("n", "<leader>il", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
keymap.set("n", "<leader>rl", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })
