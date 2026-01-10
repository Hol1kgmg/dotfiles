-- Fuzzy Finder（fff.nvim）
return {
  "dmtrKovalenko/fff.nvim",
  lazy = false,
  dependencies = {
    "folke/snacks.nvim",
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
