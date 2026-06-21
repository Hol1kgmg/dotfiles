-- help: wezterm cli コマンド (ターミナルからペイン/タブ操作)
--
-- ## ペイン分割
-- | コマンド                                      | 動作             |
-- |-----------------------------------------------|------------------|
-- | wezterm cli split-pane --right                | 右に分割         |
-- | wezterm cli split-pane --bottom               | 下に分割         |
-- | wezterm cli split-pane --left                 | 左に分割         |
-- | wezterm cli split-pane --top                  | 上に分割         |
-- | wezterm cli split-pane --right --percent 40   | 割合指定で分割   |
--
-- ## ペイン移動
-- | コマンド                                      | 動作             |
-- |-----------------------------------------------|------------------|
-- | wezterm cli activate-pane-direction Right      | 右ペインへ移動   |
-- | wezterm cli activate-pane-direction Left       | 左ペインへ移動   |
-- | wezterm cli activate-pane-direction Up         | 上ペインへ移動   |
-- | wezterm cli activate-pane-direction Down       | 下ペインへ移動   |
--
-- ## ペイン情報・操作
-- | コマンド                                      | 動作                       |
-- |-----------------------------------------------|----------------------------|
-- | wezterm cli list                              | ペイン/タブ一覧 (IDを確認) |
-- | wezterm cli kill-pane --pane-id <id>          | 指定ペインを閉じる         |
-- | wezterm cli send-text --pane-id <id> "cmd\n"  | 指定ペインにコマンド送信   |
--
-- ## 活用例: 開発用レイアウトを一発展開
-- dev_layout() {
--   wezterm cli split-pane --right --percent 40
--   wezterm cli split-pane --bottom --percent 30
-- }

local wezterm = require("wezterm")
local act = wezterm.action

local function repeat_action(action, count)
	local t = {}
	for _ = 1, count do t[#t + 1] = action end
	return act.Multiple(t)
end

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

    -- Markdown view (Alt+M で右分割してleafを起動)
		{
			key = "m",
			mods = "ALT",
			action = act.SplitPane({
				direction = "Right",
				command = { args = { "zsh", "-i", "-c", "leaf" } },
			}),
		},

		-- コピーモード (Leader+V)
		{ key = "v", mods = "LEADER", action = act.ActivateCopyMode },
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
		copy_mode = {
			-- 移動
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
			-- 選択
			{ key = "v",                action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "V",                action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			-- ヤンク
			{
				key = "y",
				action = act.Multiple({
					act.CopyTo("Clipboard"),
					act.CopyMode("Close"),
				}),
			},
			-- 終了
			{ key = "q",      action = act.CopyMode("Close") },
			{ key = "Escape", action = act.CopyMode("Close") },
		},
	},
}
