-- Markdown snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Heading 1
  s("h1", fmt("# {}", { i(0) })),

  -- Heading 2
  s("h2", fmt("## {}", { i(0) })),

  -- Heading 3
  s("h3", fmt("### {}", { i(0) })),

  -- Heading 4
  s("h4", fmt("#### {}", { i(0) })),

  -- Bold
  s("b", fmt("**{}**", { i(1) })),

  -- Italic
  s("i", fmt("*{}*", { i(1) })),

  -- Code inline
  s("c", fmt("`{}`", { i(1) })),

  -- Code block
  s("code", fmt([[
    ```{}
    {}
    ```
  ]], { i(1, "language"), i(0) })),

  -- Link
  s("link", fmt("[{}]({})", { i(1, "text"), i(2, "url") })),

  -- Image
  s("img", fmt("![{}]({})", { i(1, "alt text"), i(2, "url") })),

  -- Unordered list
  s("ul", fmt("- {}", { i(0) })),

  -- Ordered list
  s("ol", fmt("1. {}", { i(0) })),

  -- Task list
  s("task", fmt("- [ ] {}", { i(0) })),

  -- Task list (checked)
  s("taskd", fmt("- [x] {}", { i(0) })),

  -- Blockquote
  s("quote", fmt("> {}", { i(0) })),

  -- Horizontal rule
  s("hr", t("---")),

  -- Table
  s("table", fmt([[
    | {} | {} |
    | --- | --- |
    | {} | {} |
  ]], { i(1, "Header1"), i(2, "Header2"), i(3), i(0) })),

  -- Frontmatter (YAML)
  s("fm", fmt([[
    ---
    title: {}
    date: {}
    ---
  ]], { i(1, "Title"), i(2, "2024-01-01") })),
}
