-- 編集操作キーマップ（ビジュアルモード）

local keymap = vim.keymap

-- インデント調整（ビジュアルモード）
keymap.set("v", "<", "<gv", { desc = "Reduce indentation" })
keymap.set("v", ">", ">gv", { desc = "Increase indent" })

-- 行移動（ビジュアルモード）
keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "行を下に移動" })
keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "行を上に移動" })
