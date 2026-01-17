-- Fuzzy Finder（fff.nvim）
return {
  "dmtrKovalenko/fff.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>ff", "<cmd>FFFFind<CR>", desc = "fzf" },
    { "<leader><leader>", "<cmd>FFFFind<CR>", desc = "fzf" },
    { "<leader>fh", "<cmd>FFFHealth<CR>", desc = "FFF health check" },
  },
  build = ":lua require('fff.download').download_or_build_binary()",
  opts = {
    default_file_explorer = false,
    debug = {
      enabled = true,
      show_scores = true,
    },
  },
}
