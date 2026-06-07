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

		-- ペイン移動
		{ key = "h",          mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "j",          mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Down") },
		{ key = "k",          mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "l",          mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Right") },
		{ key = "LeftArrow",  mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Left") },
		{ key = "DownArrow",  mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Down") },
		{ key = "UpArrow",    mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Up") },
		{ key = "RightArrow", mods = "ALT|SHIFT", action = act.ActivatePaneDirection("Right") },

		-- ペイン分割モード (Alt+P → hjkl)
		{
			key = "p",
			mods = "ALT",
			action = act.ActivateKeyTable({ name = "split_pane", one_shot = true }),
		},

		-- ペインリサイズモード (Alt+R → hjkl, Escapeで終了)
		{
			key = "r",
			mods = "ALT",
			action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
		},

		-- Zenモードフォントサイズトグル (Neovimから呼び出し用)
		{ key = ";", mods = "CTRL", action = act.EmitEvent("toggle-font-size") },
	},

	key_tables = {
		split_pane = {
			{ key = "h",               action = act.SplitPane({ direction = "Left", size = { Percent = 33 } }) },
			{ key = "j",               action = act.SplitPane({ direction = "Down", size = { Percent = 33 } }) },
			{ key = "k",               action = act.SplitPane({ direction = "Up" }) },
			{ key = "l",               action = act.SplitPane({ direction = "Right" }) },
			{ key = "q",               action = act.CloseCurrentPane({ confirm = true }) },
			{ key = "h", mods = "ALT", action = act.SplitPane({ direction = "Left", size = { Percent = 33 } }) },
			{ key = "j", mods = "ALT", action = act.SplitPane({ direction = "Down", size = { Percent = 33 } }) },
			{ key = "k", mods = "ALT", action = act.SplitPane({ direction = "Up" }) },
			{ key = "l", mods = "ALT", action = act.SplitPane({ direction = "Right" }) },
			{ key = "q", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
		},
		resize_pane = {
			{ key = "h",      action = act.AdjustPaneSize({ "Left", 3 }) },
			{ key = "j",      action = act.AdjustPaneSize({ "Down", 3 }) },
			{ key = "k",      action = act.AdjustPaneSize({ "Up", 3 }) },
			{ key = "l",      action = act.AdjustPaneSize({ "Right", 3 }) },
			{ key = "Escape", action = act.PopKeyTable },
		},
	},
}
