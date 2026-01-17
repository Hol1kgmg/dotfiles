-- キーバインドヘルプ（mini.clue）
return {
  "echasnovski/mini.clue",
  version = false,
  event = "VeryLazy",
  config = function()
    local miniclue = require("mini.clue")
    miniclue.setup({
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        { mode = "n", keys = "d" },
        { mode = "x", keys = "d" },
        { mode = "n", keys = "s" },
        { mode = "x", keys = "s" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },
      clues = {
        { mode = "n", keys = "<Leader>f", desc = "+Find" },
        { mode = "n", keys = "<Leader>l", desc = "+Lazy" },
        { mode = "n", keys = "<Leader>g", desc = "+Go" },
        { mode = "n", keys = "<Leader>c", desc = "+Coding Agent" },
        { mode = "n", keys = "<Leader>r", desc = "+Re-Action" },
        { mode = "n", keys = "<leader>m", desc = "+Make Action" },
        { mode = "n", keys = "<Leader>i", desc = "+Info-View" },
        { mode = "n", keys = "<Leader>h", desc = "+Hunk" },

        { mode = "n", keys = "gd",        desc = "go to definition" },
        { mode = "n", keys = "gr",        desc = "find references" },
        { mode = "n", keys = "gD",        desc = "go to declaration" },
        { mode = "n", keys = "gi",        desc = "go to implementation" },
        { mode = "n", keys = "gf",        desc = "go to file" },
        { mode = "n", keys = "gx",        desc = "open URL" },
        { mode = "n", keys = "gcc",       desc = "toggle comment" },
        { mode = "n", keys = "gq",        desc = "format text" },
        { mode = "n", keys = "g*",        desc = "search word forward" },
        { mode = "n", keys = "g#",        desc = "search word backward" },
        -- mini.surround
        { mode = "n", keys = "sa",        desc = "Add surrounding" },
        { mode = "n", keys = "sd",        desc = "Delete surrounding" },
        { mode = "n", keys = "sr",        desc = "Replace surrounding" },
        { mode = "n", keys = "sf",        desc = "Find surrounding (right)" },
        { mode = "n", keys = "sF",        desc = "Find surrounding (left)" },
        { mode = "n", keys = "sh",        desc = "Highlight surrounding" },
        { mode = "n", keys = "sn",        desc = "Update n_lines" },
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
      },
      window = {
        delay = 300,
      },
    })
  end,
}
