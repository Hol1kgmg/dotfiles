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
    map("n", "gD", vim.lsp.buf.declaration, "go to declaration")

    -- ホバー・シグネチャヘルプ
    map("n", "K", vim.lsp.buf.hover, "hover documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "signature help")

    -- コード操作
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "rename")

    -- フォーマット
    map("n", "<leader>mf", function()
      vim.lsp.buf.format({ async = true })
    end, "format")
  end,
})

-- LSP custom command
keymap.set("n", "<leader>il", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
keymap.set("n", "<leader>rl", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })


-- trouble.nvim
keymap.set("n", "de", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
keymap.set("n", "dr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "References" })
keymap.set("n", "di", "<cmd>Trouble lsp_implementations toggle<cr>", { desc = "Implementation" })
keymap.set("n", "dE", "<cmd>Trouble lsp_definitions toggle<cr>", { desc = "Definition" })
keymap.set("n", "dt", "<cmd>Trouble lsp_type_definitions toggle<cr>", { desc = "Type Definitions" })
keymap.set("n", "ds", "<cmd>Trouble symbols toggle<cr>", { desc = "Document Symbols" })
keymap.set("n", "dc", "<cmd>Trouble lsp_incoming_calls toggle<cr>", { desc = "Incoming Calls" })
keymap.set("n", "dC", "<cmd>Trouble lsp_outgoing_calls toggle<cr>", { desc = "Outgoing Calls" })





