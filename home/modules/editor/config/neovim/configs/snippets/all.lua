-- Folder name snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- nix default.nix
  s("default", {
    t("default.nix")
  }),

  -- lua init.lua
  s("init", {
    t("init.lua")
  }),

  -- React project directories
  s("components-set", {
    t({"components/", "hooks/", "libs/", "types/"})
  }),
}
