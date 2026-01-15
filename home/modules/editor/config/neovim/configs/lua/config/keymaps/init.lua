-- キーマップ設定（統合版）
-- プラグイン固有キーマップ: keymaps/plugins/
---@diagnostic disable: undefined-global

local keymap = vim.keymap

-- ============================================================
-- BASIC - 基本操作
-- ============================================================

-- ファイル操作
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "save" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "quit" })
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "force quit(not save)" })

-- ターミナルモード終了
keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "exit terminal mode" })

-- 検索ハイライトをクリア
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Lazy.nvim
keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "open Lazy.nvim" })
keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "open Lazy update" })

-- ターミナル
keymap.set("n", "<leader>t", function()
  Snacks.terminal()
end, { desc = "open terminal (split)" })

-- バッファターミナルの連番カウンタ
local term_count = 0

keymap.set("n", "<leader>T", function()
  vim.cmd("enew")
  vim.cmd("terminal")
  local bufnr = vim.api.nvim_get_current_buf()
  term_count = term_count + 1
  vim.api.nvim_buf_set_name(bufnr, "Terminal " .. term_count)
  vim.cmd("startinsert")
end, { desc = "open terminal (buffer)" })

-- lazydocker
keymap.set("n", "<leader>ld", function()
  Snacks.terminal("lazydocker", { win = { position = "float" } })
end, { desc = "open lazydocker" })

-- ============================================================
-- NAVIGATION - ウィンドウ・バッファ操作
-- ============================================================

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "to bottom window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "to top window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "to right window" })

-- バッファ移動
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "previous buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })

-- Bufferで開いているファイル相対パスをコピー
keymap.set("n", "<leader>y", function()
  local relative_path = vim.fn.expand("%:.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Copy: " .. relative_path)
end, { desc = "copy file path", silent = true })

-- Bufferで開いているファイル名をコピー
keymap.set("n", "<leader>Y", function ()
  local filename = vim.fn.expand("%:t")
  vim.fn.setreg("+", filename)
  vim.notify("Copy: " .. filename)
end, { desc = "copy file name", silent = true })

-- Buffer削除
keymap.set("n", "q", function()
  if vim.bo.buftype == "terminal" then
    vim.cmd("bd!")  -- ターミナルは強制削除
  else
    vim.cmd("bd")   -- 通常バッファは警告あり
  end
end, { desc = "quit buffer" })

-- Zenモード
keymap.set("n", "<leader>z", function()
  Snacks.zen()
end, { desc = "toggle zen mode" })

-- ============================================================
-- EDITING - 編集操作
-- ============================================================

-- s キーを無効化（mini.surroundのデフォルトキーマップを使用するため）
keymap.set("n", "s", "<Nop>", { desc = "Disabled for mini.surround" })
keymap.set("x", "s", "<Nop>", { desc = "Disabled for mini.surround" })

-- インデント調整（ビジュアルモード）
keymap.set("v", "<", "<gv", { desc = "Reduce indentation" })
keymap.set("v", ">", ">gv", { desc = "Increase indent" })

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "行を下に移動" })
keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "行を上に移動" })

-- vim-dogeによる関数コメント作成
keymap.set("n", "<leader>md", "<cmd>DogeGenerate<cr>", { desc = "Generate doc" })

-- ============================================================
-- FINDER - ファイル検索
-- ============================================================

-- ファイラー(oil.nvim)
-- Note: バッファ内キーマップは keymaps/plugins/oil.lua
keymap.set("n", "<leader>e", "<cmd>Oil --float<cr>", { desc = "open filer(this files)" })
keymap.set("n", "<leader>E", "<cmd>Oil . --float<cr>", { desc = "open filer (cwd)" })

-- Fuzzy Finder（fff.nvim）
keymap.set("n", "<leader>ff", "<cmd>FFFFind<CR>", { desc = "fzf" })
keymap.set("n", "<leader><leader>", "<cmd>FFFFind<CR>", { desc = "fzf" })
keymap.set("n", "<leader>fh", "<cmd>FFFHealth<CR>", { desc = "FFF health check" })

-- snacks.picker
keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "buffer list" })
keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "live grep" })

-- ============================================================
-- GIT - Git操作
-- ============================================================
-- Note: gitsigns バッファキーマップは keymaps/plugins/gitsigns.lua

-- Git操作（snacks.nvim）
keymap.set("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "LazyGit" })

keymap.set("n", "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git open browser" })

-- ============================================================
-- LSP - 言語サーバー
-- ============================================================

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

    -- LSPのcode actionを実行
    map("n", "<leader>mc", vim.lsp.buf.code_action, "LSP:code_action")
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

-- ============================================================
-- AI - AI連携
-- ============================================================

-- Copilot
keymap.set("n", "<leader>co", function()
  if _G.toggle_copilot_completion then
    _G.toggle_copilot_completion()
  else
    vim.notify("Copilot toggle function is not available", vim.log.levels.ERROR)
  end
end, { desc = "toggle Copilot completion" })

-- Claude Code
keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "toggle Claude Code" })
keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", { desc = "focus Claude Code" })
keymap.set("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "select Model Claude Code" })
keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "send selection to Claude" })
keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "accept Claude diff" })
keymap.set("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "deny Claude diff" })

-- ============================================================
-- INFO - 情報表示
-- ============================================================

-- Health check
keymap.set("n", "<leader>ih", "<cmd>HealthCheck<cr>", { desc = "health check (save to /tmp)" })

-- Keymap検索
keymap.set("n", "<leader>ik", "<cmd>KeymapInfo<cr>", { desc = "inspect keymap" })

-- ============================================================
-- PLUGIN DEFAULTS (ドキュメント)
-- ============================================================
-- mini.surround: sa{motion}{char}, sd{char}, sr{old}{new}, sf, sF, sh, sn
-- mini.comment: gcc, gc{motion}
