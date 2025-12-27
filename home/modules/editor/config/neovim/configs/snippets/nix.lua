-- Nix snippets
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Let-in expression
  s("let", fmt([[
    let
      {} = {};
    in
      {}
  ]], { i(1, "name"), i(2, "value"), i(0) })),

  -- With statement
  s("with", fmt("with {}; {}", { i(1, "pkgs"), i(0) })),

  -- Function definition
  s("fn", fmt("{}: {}", { i(1, "args"), i(0) })),

  -- Inherit
  s("inh", fmt("inherit ({}) {};", { i(1), i(0) })),

  -- mkDerivation
  s("mkd", fmt([[
    stdenv.mkDerivation {{
      pname = "{}";
      version = "{}";

      src = fetchurl {{
        url = "{}";
        sha256 = "{}";
      }};

      {}
    }}
  ]], { i(1, "package-name"), i(2, "0.1.0"), i(3), i(4), i(0) })),

  -- buildInputs
  s("bi", fmt("buildInputs = [ {} ];", { i(0) })),

  -- nativeBuildInputs
  s("nbi", fmt("nativeBuildInputs = [ {} ];", { i(0) })),

  -- Home-Manager module
  s("hm", fmt([[
    {{ config, pkgs, ... }}:

    {{
      {}
    }}
  ]], { i(0) })),

  -- mkIf
  s("mkif", fmt("mkIf {} {}", { i(1, "condition"), i(0) })),

  -- mkOption
  s("opt", fmt([[
    {} = mkOption {{
      type = types.{};
      default = {};
      description = "{}";
    }};
  ]], { i(1, "optionName"), i(2, "bool"), i(3, "false"), i(4) })),

  -- Import
  s("imp", fmt("import {}", { i(0) })),
}
