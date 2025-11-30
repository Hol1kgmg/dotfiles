local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		-- タブ切り替え
		{ key = "[", mods = "SUPER", action = act.ActivateTabRelative(-1) },
		{ key = "]", mods = "SUPER", action = act.ActivateTabRelative(1) },

		-- ペイン操作
		{ key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "w", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "[", mods = "ALT|SUPER", action = act.ActivatePaneDirection("Left") },
		{ key = "LeftArrow", mods = "SUPER", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "]", mods = "ALT|SUPER", action = act.ActivatePaneDirection("Right") },
		{ key = "RightArrow", mods = "SUPER", action = act.AdjustPaneSize({ "Right", 1 }) },
	},

	key_tables = {
		-- デフォルトのkey_tablesを使用
	},
}
