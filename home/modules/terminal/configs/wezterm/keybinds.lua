local wezterm = require("wezterm")
local act = wezterm.action

local new_workspace_count = 0

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
			action = wezterm.action_callback(function(window, pane)
				new_workspace_count = new_workspace_count + 1
				local name = new_workspace_count == 1 and "new" or "new" .. new_workspace_count
				window:perform_action(
					act.SwitchToWorkspace({
						name = name,
						spawn = { args = { "zsh", "-i", "-c", "cdi; exec zsh" } },
					}),
					pane
				)
			end),
		},

		-- リネーム選択 (workspace / tab)
		{
			key = "R",
			mods = "SUPER",
			action = wezterm.action_callback(function(window, pane)
				-- workspace候補名をcwdから取得（ラベル表示用）
				local cwd_uri = pane:get_current_working_dir()
				local cwd_name = ""
				if cwd_uri then
					local path = cwd_uri.file_path:gsub("/$", "")
					cwd_name = path:match("([^/]+)$") or ""
				end

				window:perform_action(
					act.InputSelector({
						title = "リネーム対象を選択",
						choices = {
							{
								id = "workspace",
								label = "workspace → " .. (cwd_name ~= "" and cwd_name or "(cwdが取得できません)"),
							},
							{ id = "tab", label = "tab → 名前を入力..." },
						},
						action = wezterm.action_callback(function(win, p, id, _)
							if id == "workspace" then
								local current = win:active_workspace()
								local uri = p:get_current_working_dir()
								if uri then
									local path2 = uri.file_path:gsub("/$", "")
									local new_name = path2:match("([^/]+)$")
									if new_name and new_name ~= "" then
										wezterm.mux.rename_workspace(current, new_name)
									end
								end
							elseif id == "tab" then
								win:perform_action(
									act.PromptInputLine({
										description = "タブ名を入力",
										action = wezterm.action_callback(function(w, _, line)
											if line and line ~= "" then
												w:active_tab():set_title(line)
											end
										end),
									}),
									p
								)
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
