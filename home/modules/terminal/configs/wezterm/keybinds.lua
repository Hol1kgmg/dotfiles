local wezterm = require("wezterm")
local act = wezterm.action

return {
	keys = {
		-- タブ切り替え
		{ key = "h", mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "l", mods = "ALT", action = act.ActivateTabRelative(1) },

		-- 新しいタブ (WezTermデフォルトのCmd+t を明示)
		{ key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },

		-- 新しいワークスペース (cdiでディレクトリ選択)
		{
			key = "T",
			mods = "SUPER",
			action = act.SwitchToWorkspace({
				name = "new",
				spawn = { args = { "zsh", "-i", "-c", "cdi; exec zsh" } },
			}),
		},

		-- ワークスペース名変更 (カレントディレクトリ名)
		{
			key = "R",
			mods = "SUPER",
			action = wezterm.action_callback(function(window, pane)
				local current = window:active_workspace()
				local cwd_uri = pane:get_current_working_dir()
				if cwd_uri then
					local path = cwd_uri.file_path:gsub("/$", "")
					local new_name = path:match("([^/]+)$")
					if new_name and new_name ~= "" then
						wezterm.mux.rename_workspace(current, new_name)
					end
				end
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
