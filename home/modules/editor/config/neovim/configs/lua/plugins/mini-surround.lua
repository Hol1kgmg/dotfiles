-- 囲み操作
-- Docs: https://github.com/echasnovski/mini.surround
-- sa{motion}{char}: 囲みを追加
-- sd{char}: 囲みを削除
-- sr{old}{new}: 囲みを置換
-- sf/sF/sh/sn: 囲みを検索
return {
  'echasnovski/mini.surround',
  event = "VeryLazy",
  keys = {
    -- s キーを無効化（mini.surroundのデフォルトキーマップを使用するため）
    { "s", "<Nop>", mode = "n", desc = "Disabled for mini.surround" },
    { "s", "<Nop>", mode = "x", desc = "Disabled for mini.surround" },
  },
  opts = {},
}
