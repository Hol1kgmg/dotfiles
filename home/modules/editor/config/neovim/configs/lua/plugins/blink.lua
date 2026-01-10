-- 補完エンジン
-- Docs: https://cmp.saghen.dev/
-- Note: buildフィールドを削除し、GitHubリリース版のプリビルドバイナリを使用
-- Copilot統合はcopilot.luaで設定
return {
  'saghen/blink.cmp',
  version = 'v0.*',
  event = { "InsertEnter", "CmdLineEnter" },
  dependencies = { "giuxtaposition/blink-cmp-copilot" },
  config = function()
    -- Copilot補完の状態管理（デフォルトはfalse）
    local copilot_enabled = false

    -- Copilotトグル関数をグローバルに公開
    ---@diagnostic disable-next-line: duplicate-set-field
    _G.toggle_copilot_completion = function()
      copilot_enabled = not copilot_enabled

      -- blink.cmpを再読み込み
      local ok, _ = pcall(require, "blink.cmp")
      if ok then
        vim.cmd("silent! BlinkCmpReload")
      end

      -- 状態を通知
      local status = copilot_enabled and "ON" or "OFF"
      vim.notify("Copilot: " .. status, vim.log.levels.INFO)
    end

    -- blink.cmpのセットアップ
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
        default = { "copilot", "snippets", "lsp", "path", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100, -- 優先度を高く設定
            async = true,
            enabled = function()
              return copilot_enabled -- local変数を直接参照
            end,
          },
        },
        per_filetype = {
          markdown = { "copilot", "snippets", "lsp", "path" },
          mdx = { "copilot", "snippets", "lsp", "path" },
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
