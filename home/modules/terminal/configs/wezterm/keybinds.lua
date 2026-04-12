local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		-- タブ切り替え
		{ key = "h",          mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "l",          mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "LeftArrow",  mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", mods = "ALT", action = act.ActivateTabRelative(1) },

		-- 新しいタブ ("tab" で固定命名)
		{
			key = "t",
			mods = "SUPER",
			action = wezterm.action_callback(function(window, _)
				local tab, _, _ = window:mux_window():spawn_tab({})
				tab:set_title("tab")
			end),
		},

		-- 新しいワークスペース (cdiでディレクトリ選択)
		{
			key = "T",
			mods = "SUPER",
			action = act.SwitchToWorkspace({
				spawn = { args = { "zsh", "-i", "-c", "cdi; exec zsh" } },
			}),
		},

		-- タブリネーム
		{
			key = "R",
			mods = "SUPER",
			action = wezterm.action_callback(function(window, pane)
				window:perform_action(
					act.PromptInputLine({
						description = "タブ名を入力",
						action = wezterm.action_callback(function(w, _, line)
							if line and line ~= "" then
								w:active_tab():set_title(line)
							end
						end),
					}),
					pane
				)
			end),
		},

		-- ワークスペース切り替え
		{ key = "Tab", mods = "CTRL",       action = act.SwitchWorkspaceRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) },

		-- Zenモードフォントサイズトグル (Neovimから呼び出し用)
		{ key = ";", mods = "CTRL", action = act.EmitEvent("toggle-font-size") },
	},

	key_tables = {},
}
