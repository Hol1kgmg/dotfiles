-- Python snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Print statement
  s("print", fmt("print({})", { i(1) })),

  -- Import
  s("imp", fmt("import {}", { i(1) })),

  -- Import from
  s("impf", fmt("from {} import {}", { i(1), i(2) })),

  -- Function definition
  s("def", fmt([[
    def {}({}):
        {}
  ]], { i(1, "function_name"), i(2), i(0) })),

  -- Async function
  s("adef", fmt([[
    async def {}({}):
        {}
  ]], { i(1, "function_name"), i(2), i(0) })),

  -- Class definition
  s("class", fmt([[
    class {}:
        def __init__(self{}):
            {}
  ]], { i(1, "ClassName"), i(2), i(0) })),

  -- If statement
  s("if", fmt([[
    if {}:
        {}
  ]], { i(1, "condition"), i(0) })),

  -- If-else
  s("ife", fmt([[
    if {}:
        {}
    else:
        {}
  ]], { i(1, "condition"), i(2), i(0) })),

  -- For loop
  s("for", fmt([[
    for {} in {}:
        {}
  ]], { i(1, "item"), i(2, "items"), i(0) })),

  -- While loop
  s("while", fmt([[
    while {}:
        {}
  ]], { i(1, "condition"), i(0) })),

  -- Try-except
  s("try", fmt([[
    try:
        {}
    except {} as {}:
        {}
  ]], { i(1), i(2, "Exception"), i(3, "e"), i(0) })),

  -- With statement
  s("with", fmt([[
    with {} as {}:
        {}
  ]], { i(1), i(2, "f"), i(0) })),

  -- Main guard
  s("main", fmt([[
    if __name__ == "__main__":
        {}
  ]], { i(0) })),

  -- Docstring
  s("doc", fmt('"""{}"""', { i(0) })),
}
