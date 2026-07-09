local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)

  -- search mode用のplugin
	local search_mode_esc = wezterm.plugin.require("https://github.com/Hol1kgmg/search-mode-esc.wezterm")
	search_mode_esc.apply_to_config(config)

end

return M
