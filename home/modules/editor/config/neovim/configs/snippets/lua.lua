-- Lua snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- scratch template
  s("scratch_tmp", fmt('s("{}", fmt("{}")),',{ i(1, "name"), i(2, "value")})),

  --- keymap
  s("keymap_tmp", fmt('keymap.set("n", "<leader>{}", "<cmd>{}<cr>"),', { i(1, "keymap"), i(2, "name")})),

  -- Print statement
  s("print", fmt("print({})", { i(1) })),

  -- Require module
  s("req", fmt('local {} = require("{}")', { i(1, "module"), i(2) })),

  -- Function definition
  s("fn", fmt([[
    function {}({})
      {}
    end
  ]], { i(1, "name"), i(2), i(0) })),

  -- Local function
  s("lfn", fmt([[
    local function {}({})
      {}
    end
  ]], { i(1, "name"), i(2), i(0) })),

  -- If statement
  s("if", fmt([[
    if {} then
      {}
    end
  ]], { i(1, "condition"), i(0) })),

  -- For loop
  s("for", fmt([[
    for {} = {}, {} do
      {}
    end
  ]], { i(1, "i"), i(2, "1"), i(3, "10"), i(0) })),

  -- For ipairs
  s("forp", fmt([[
    for {}, {} in ipairs({}) do
      {}
    end
  ]], { i(1, "i"), i(2, "v"), i(3, "table"), i(0) })),

  -- For pairs
  s("forpp", fmt([[
    for {}, {} in pairs({}) do
      {}
    end
  ]], { i(1, "k"), i(2, "v"), i(3, "table"), i(0) })),
}
