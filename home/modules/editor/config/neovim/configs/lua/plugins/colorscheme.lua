-- カラースキーム
return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- カラースキームは最優先で読み込む
    config = function()
      require("kanagawa").setup({
        compile = false, -- コンパイル機能を無効化（高速化）
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true, -- 背景を透過する
        dimInactive = false, -- 非アクティブウィンドウを暗くしない
        terminalColors = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none", -- 行番号背景を透明に
              },
            },
          },
        },
        overrides = function(_colors)
          return {
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
          }
        end,
      })
      -- カラースキームを適用
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}
