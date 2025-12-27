-- TypeScript/JavaScript snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Console log
  s("log", fmt("console.log({});", { i(1) })),

  -- Console error
  s("err", fmt("console.error({});", { i(1) })),

  -- Console warn
  s("warn", fmt("console.warn({});", { i(1) })),

  -- Arrow function
  s("af", fmt("const {} = ({}) => {}", { i(1, "name"), i(2), i(0) })),

  -- Async arrow function
  s("aaf", fmt("const {} = async ({}) => {}", { i(1, "name"), i(2), i(0) })),

  -- Function declaration
  s("fn", fmt([[
    function {}({}) {{
      {}
    }}
  ]], { i(1, "name"), i(2), i(0) })),

  -- Async function
  s("afn", fmt([[
    async function {}({}) {{
      {}
    }}
  ]], { i(1, "name"), i(2), i(0) })),

  -- Interface
  s("int", fmt([[
    interface {} {{
      {}
    }}
  ]], { i(1, "Name"), i(0) })),

  -- Type alias
  s("type", fmt("type {} = {}", { i(1, "Name"), i(0) })),

  -- Try-catch
  s("try", fmt([[
    try {{
      {}
    }} catch (error) {{
      {}
    }}
  ]], { i(1), i(0) })),

  -- Import
  s("imp", fmt('import {{ {} }} from "{}";', { i(1), i(2) })),

  -- Import default
  s("impd", fmt('import {} from "{}";', { i(1, "module"), i(2) })),

  -- Export
  s("exp", fmt("export {{ {} }}", { i(0) })),

  -- Export default
  s("expd", fmt("export default {}", { i(0) })),
}
