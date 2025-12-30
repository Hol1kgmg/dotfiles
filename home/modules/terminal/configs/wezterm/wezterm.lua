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
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

----------------------------------------------------
-- タブバー設定
----------------------------------------------------
config.show_tabs_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

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
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

----------------------------------------------------
-- イベントハンドラ
----------------------------------------------------
-- フォントサイズトグル
wezterm.on('toggle-font-size', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = not overrides.font_size and 18.0 or nil
  window:set_config_overrides(overrides)
end)

return config
