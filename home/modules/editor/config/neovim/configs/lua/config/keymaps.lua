local keymap = vim.keymap

-- 基本操作
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "保存" })
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "終了" })
keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "全て終了（保存なし）" })

-- 検索ハイライトをクリア
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

-- バッファ移動
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "前のバッファ" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "次のバッファ" })

-- インデント調整（ビジュアルモード）
keymap.set("v", "<", "<gv", { desc = "インデントを減らす" })
keymap.set("v", ">", ">gv", { desc = "インデントを増やす" })

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "行を下に移動" })
keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "行を上に移動" })

-- ファイラー（mini.files）
keymap.set("n", "<leader>e", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0))
end, { desc = "ファイラーを開く（現在のファイル）" })

keymap.set("n", "<leader>E", function()
  require("mini.files").open()
end, { desc = "ファイラーを開く（cwd）" })

-- ファジーファインダー（fff.nvim）
keymap.set("n", "<leader>ff", "<cmd>FFFFind<CR>", { desc = "ファイル検索" })
keymap.set("n", "<leader>fb", "<cmd>FFFFind buffer<CR>", { desc = "バッファ一覧" })
keymap.set("n", "<leader>fh", "<cmd>FFFFind oldfiles<CR>", { desc = "最近開いたファイル" })

-- snacks.nvim（ターミナル・Git）
keymap.set("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "LazyGit" })

keymap.set("n", "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Gitブラウザで開く" })

keymap.set("n", "<leader>t", function()
  Snacks.terminal()
end, { desc = "ターミナルを開く" })
