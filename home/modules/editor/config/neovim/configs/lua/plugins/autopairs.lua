-- 自動括弧補完
return {
  "windwp/nvim-autopairs",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    check_ts = true,
  },
}
