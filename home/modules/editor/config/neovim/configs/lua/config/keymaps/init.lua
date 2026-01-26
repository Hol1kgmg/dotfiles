-- キーマップ設定（統合版）
-- プラグイン固有キーマップ: 各プラグインファイル (lua/plugins/*.lua)
-- バッファローカルキーマップ: keymaps/plugins/
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

-- hlslens 検索
local opts = { silent = true }
keymap.set("n", "*", function()
  local hlslens = require("hlslens")
  local current_word = vim.fn.expand("<cword>")
  vim.fn.histadd("search", current_word)
  vim.fn.setreg("/", current_word)
  vim.opt.hlsearch = true
  hlslens.start()
end, opts)

keymap.set("n", "#", function()
  local hlslens = require("hlslens")
  local current_word = vim.fn.expand("<cword>")
  vim.api.nvim_feedkeys(":%s/" .. current_word .. "//g", "n", false)
  local ll = vim.api.nvim_replace_termcodes("<Left><Left>", true, true, true)
  vim.api.nvim_feedkeys(ll, "n", false)
  vim.opt.hlsearch = true
  hlslens.start()
end, opts)
-- Lazy.nvim
keymap.set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "open Lazy.nvim" })
keymap.set("n", "<leader>lu", "<cmd>Lazy update<cr>", { desc = "open Lazy update" })

-- ============================================================
-- NAVIGATION - ウィンドウ・バッファ操作
-- ============================================================
-- 10行移動
keymap.set("n", "J", "10j", { desc = "10j 移動" })
keymap.set("n", "K", "10k", { desc = "10k 移動" })

-- ウィンドウ移動
keymap.set("n", "<leader>gh", "<C-w>h", { desc = "to left window" })
keymap.set("n", "<leader>gj", "<C-w>j", { desc = "to bottom window" })
keymap.set("n", "<leader>gk", "<C-w>k", { desc = "to top window" })
keymap.set("n", "<leader>gl", "<C-w>l", { desc = "to right window" })

-- バッファ移動
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "previous buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "next buffer" })

-- Bufferで開いているファイルのリポジトリルートからのパスをコピー
keymap.set("n", "<leader>y", function()
  local file_path = vim.fn.expand("%:p") -- 絶対パス
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if git_root and vim.v.shell_error == 0 then
    local relative_path = file_path:sub(#git_root + 2) -- +2 は "/" の分
    vim.fn.setreg("+", relative_path)
    vim.notify("Copy: " .. relative_path)
  else
    -- gitリポジトリでない場合は従来通り
    local relative_path = vim.fn.expand("%:.")
    vim.fn.setreg("+", relative_path)
    vim.notify("Copy: " .. relative_path)
  end
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

-- ============================================================
-- EDITING - 編集操作
-- ============================================================

-- インデント調整（ビジュアルモード）
keymap.set("v", "<", "<gv", { desc = "Reduce indentation" })
keymap.set("v", ">", ">gv", { desc = "Increase indent" })

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "行を下に移動" })
keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "行を上に移動" })

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
