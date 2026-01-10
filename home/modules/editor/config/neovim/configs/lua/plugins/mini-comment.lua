-- コメント操作
-- Docs: https://github.com/echasnovski/mini.comment
-- gcc: 行コメントトグル
-- gc{motion}: モーション範囲をコメント
-- ビジュアルモードでも動作
return {
  'echasnovski/mini.comment',
  event = "VeryLazy",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  opts = {
    options = {
      custom_commentstring = function()
        return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
      end,
    },
  },
}
