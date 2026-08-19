local wezterm = require("wezterm")
local act = wezterm.action

-- 連続したキー入力用 function
local function repeat_action(action, count)
	local t = {}
	for _ = 1, count do t[#t + 1] = action end
	return act.Multiple(t)
end

-- 対話シェル経由でコマンドを実行するargs (Homebrew等、対話シェルのPATHが必要なコマンド用)
local function interactive_shell(cmd)
	return { "/bin/zsh", "-i", "-c", cmd }
end

return {
	leader = { key = "Space", mods = "SHIFT", timeout_milliseconds = 1000 },

	keys = {
		-- タブ切り替え
		{ key = "h",          mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "l",          mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "LeftArrow",  mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", mods = "ALT", action = act.ActivateTabRelative(1) },

    -- 新しいタブ ("tab"で固定命名)
    {
      key = "t",
      mods = "LEADER",
      action = wezterm.action_callback(function(window,_)
        local tab, _, _ = window:mux_window():spawn_tab({})
        tab:set_title("tab")
      end),
    },

    -- タブを閉じる
    { key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false}) },

    -- ペインを閉じる
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false}) },

		-- 新しいワークスペース (cdiでディレクトリ選択)
		{
			key = "T",
			mods = "LEADER|SHIFT",
			action = act.SwitchToWorkspace({
				spawn = { args = interactive_shell("cdi; exec zsh") },
			}),
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

		-- ペイン分割 (Leader+hjkl)
		{ key = "h", mods = "LEADER", action = act.SplitPane({ direction = "Left",  size = { Percent = 33 } }) },
		{ key = "j", mods = "LEADER", action = act.SplitPane({ direction = "Down",  size = { Percent = 33 } }) },
		{ key = "k", mods = "LEADER", action = act.SplitPane({ direction = "Up" }) },
		{ key = "l", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },

		-- ペインリサイズモード (Leader+R → hjkl, Escapeで終了)
		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
		},

		-- コピーモード (Leader+V)
		{ key = "v", mods = "LEADER", action = act.ActivateCopyMode },

		-- 専用ツール起動 (herdr の popup 相当を新規タブで実行、対話シェル経由でPATH解決)
		{
			key = "b",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, _)
				local tab, _, _ = window:mux_window():spawn_tab({ args = interactive_shell("btop") })
				tab:set_title("tool")
			end),
		},
		{
			key = "p",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, _)
				local tab, _, _ = window:mux_window():spawn_tab({ args = interactive_shell("localhost-top") })
				tab:set_title("tool")
			end),
		},
	},

	key_tables = {
		resize_pane = {
			{ key = "h",      action = act.AdjustPaneSize({ "Left", 3 }) },
			{ key = "j",      action = act.AdjustPaneSize({ "Down", 3 }) },
			{ key = "k",      action = act.AdjustPaneSize({ "Up", 3 }) },
			{ key = "l",      action = act.AdjustPaneSize({ "Right", 3 }) },
			{ key = "Escape", action = act.PopKeyTable },
		},
		copy_mode = {
			{ key = "h",      action = act.CopyMode("MoveLeft") },
			{ key = "j",      action = act.CopyMode("MoveDown") },
			{ key = "k",      action = act.CopyMode("MoveUp") },
			{ key = "l",      action = act.CopyMode("MoveRight") },
			{ key = "H",      action = repeat_action(act.CopyMode("MoveLeft"), 10) },
			{ key = "J",      action = repeat_action(act.CopyMode("MoveDown"), 10) },
			{ key = "K",      action = repeat_action(act.CopyMode("MoveUp"),   10) },
			{ key = "L",      action = repeat_action(act.CopyMode("MoveRight"), 10) },
			{ key = "w",      action = act.CopyMode("MoveForwardWord") },
			{ key = "b",      action = act.CopyMode("MoveBackwardWord") },
			{ key = "0",      action = act.CopyMode("MoveToStartOfLine") },
			{ key = "$",      action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "g",      action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "G",      action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "v",                action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "V",                action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			{
				key = "y",
				action = act.Multiple({
					act.CopyTo("Clipboard"),
					act.CopyMode("Close"),
				}),
			},
			{ key = "a",      action = act.CopyMode("Close") },
			{ key = "q",      action = act.CopyMode("Close") },
			{ key = "Escape", action = act.CopyMode("Close") },
		},
	},
}
