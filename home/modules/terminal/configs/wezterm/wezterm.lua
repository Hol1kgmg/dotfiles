local wezterm = require("wezterm")
local config = wezterm.config_builder()

----------------------------------------------------
-- 基本設定
----------------------------------------------------
config.automatically_reload_config = true
config.use_ime = true
config.ime_preedit_rendering = "Builtin"

----------------------------------------------------
-- ウィンドウ・透過設定
----------------------------------------------------
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20

----------------------------------------------------
-- タブバー設定
----------------------------------------------------
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.window_background_gradient = {
  colors = { "#000000" },
}
-- タブバーにワークスペース名を表示
wezterm.on("update-right-status", function(window, _)
	window:set_right_status(wezterm.format({
		{ Foreground = { AnsiColor = "Silver" } },
		{ Text = " " .. window:active_workspace() .. " " },
	}))
end)

----------------------------------------------------
-- フォント設定
----------------------------------------------------
config.font = wezterm.font("PlemolJP Console NF")
config.font_size = 13.0
config.adjust_window_size_when_changing_font_size = false

----------------------------------------------------
-- キーバインド設定
----------------------------------------------------
config.disable_default_key_bindings = false
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

----------------------------------------------------
-- イベントハンドラ
----------------------------------------------------
-- フォントサイズトグル
wezterm.on("toggle-font-size", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	overrides.font_size = not overrides.font_size and 18.0 or nil
	window:set_config_overrides(overrides)
end)

return config
