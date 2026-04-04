-- スニペットエンジン
return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local luasnip = require("luasnip")

    -- VSCodeスニペット読み込み（friendly-snippets）
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 不要なスニペットを削除
    local function remove_snippets(ft, triggers)
      local snips = luasnip.get_snippets(ft)
      luasnip.filetype_set(ft, vim.tbl_filter(function(snip)
        return not vim.tbl_contains(triggers, snip.trigger)
      end, snips))
    end

    remove_snippets("typescript", { "log" })
    remove_snippets("typescriptreact", { "log" })

    -- カスタムスニペット読み込み（Luaファイル）
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" }
    })

    -- 基本設定
    luasnip.config.setup({
      history = true,
      updateevents = "TextChanged,TextChangedI",
    })

    -- ファイルタイプ継承設定
    luasnip.filetype_extend("typescriptreact", { "typescript" })
  end,
}
