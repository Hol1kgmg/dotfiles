-- AI統合機能
return {
  -- Claude Code 統合
  {
    "greggh/claude-code.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("claude-code").setup({
        window = {
          position = "float",

          float = {
            width = "30%",
            height = "100%",
            row = "0%",
            col = "100%",
            relative = "editor",
            border = "rounded",
          }
        }
      })
    end,
  },
}
