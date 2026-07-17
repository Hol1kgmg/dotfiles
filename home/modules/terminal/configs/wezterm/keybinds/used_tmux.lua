local wezterm = require("wezterm")

-- タブが複数あれば次のタブへ移動、単独タブならTabキーをそのまま送信
local function tab_or_next(win, pane)
	if #win:mux_window():tabs() > 1 then
		win:perform_action(wezterm.action.ActivateTabRelative(1), pane)
	else
		win:perform_action(wezterm.action.SendKey({ key = "Tab" }), pane)
	end
end

-- タブが複数あれば前のタブへ移動、単独タブならShift+Tabをそのまま送信
local function shift_tab_or_prev(win, pane)
	if #win:mux_window():tabs() > 1 then
		win:perform_action(wezterm.action.ActivateTabRelative(-1), pane)
	else
		win:perform_action(wezterm.action.SendKey({ key = "Tab", mods = "SHIFT" }), pane)
	end
end

return {
	keys = {
		-- tmux系マルチプレクサのprefixとしてshift+spaceをKKPシーケンスで送信
		{ key = "Space", mods = "SHIFT",   action = wezterm.action.SendString("\x1b[32;2u") },
		-- Cmd+S をKKPシーケンスとして転送 (herdrのsidebar toggleへ届けるため)
		{ key = "s",     mods = "SUPER",   action = wezterm.action.SendString("\x1b[115;9u") },
    -- Ctrl+Tab / Ctrl+Shift+Tab をKKPシーケンスとして転送(herdrのworkspace切り替えへ)
    -- WezTerm workspaceは意図的に未割り当て(デフォルトのタブ切り替えもここで上書き)
    { key = "Tab", mods = "CTRL",      action = wezterm.action.SendString("\x1b[9;5u]") },
    { key = "Tab", mods = "CTRL|SHIFT",action = wezterm.action.SendString("\x1b[9;6u]") },
		-- タブが複数あればnext/prev tab、単独ならそのまま送信
		{ key = "Tab",   mods = "",        action = wezterm.action_callback(tab_or_next) },
		{ key = "Tab",   mods = "SHIFT",   action = wezterm.action_callback(shift_tab_or_prev) },
	},

	key_tables = {},
}
