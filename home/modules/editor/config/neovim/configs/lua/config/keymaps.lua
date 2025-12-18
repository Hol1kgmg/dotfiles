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
