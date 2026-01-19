-- 補完エンジン
-- Docs: https://cmp.saghen.dev/
-- Note: buildフィールドを削除し、GitHubリリース版のプリビルドバイナリを使用
return {
  'saghen/blink.cmp',
  version = 'v0.*',
  dependencies = { "L3MON4D3/LuaSnip" },
  event = { "InsertEnter", "CmdLineEnter" },
  config = function()
    require('blink.cmp').setup({
      -- キーマップ設定（デフォルト使用）
      -- カスタマイズ方法: https://cmp.saghen.dev/configuration/keymap.html#default
      keymap = { preset = 'super-tab' },

      -- 外観設定
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      -- 補完ソース設定
      sources = {
        default = { "snippets", "lsp", "path", "buffer" },
        per_filetype = {
          markdown = { "snippets", "lsp", "path" },
          mdx = { "snippets", "lsp", "path" },
        },
      },

      -- スニペット設定
      snippets = { preset = "luasnip" },

      -- 補完動作設定
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = {
          enabled = true,
        },
      },

      -- シグネチャヘルプ
      signature = {
        enabled = true,
      },
    })
  end,
}
