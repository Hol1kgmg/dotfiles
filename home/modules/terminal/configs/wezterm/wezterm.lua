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
-- フォント設定
----------------------------------------------------
config.font = wezterm.font("PlemolJP Console NF")
config.font_size = 13.0
config.adjust_window_size_when_changing_font_size = false

----------------------------------------------------
-- タブバー設定
----------------------------------------------------
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.tab_max_width = 12
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
  font_size = 16.0,
}
config.window_background_gradient = {
  colors = { "#000000" },
}

----------------------------------------------------
-- キーバインド設定
----------------------------------------------------
config.disable_default_key_bindings = false
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

----------------------------------------------------
-- 定数
----------------------------------------------------
local TAB_WIDTH = config.tab_max_width

-- _inverseの高さが数ドットだけ狭くなる不具合があるので、別のスタイルを適応
-- local TAB_LEFT_SHAPE = wezterm.nerdfonts.ple_left_hard_divider_inverse
-- local TAB_RIGHT_SHAPE = wezterm.nerdfonts.pl_left_hard_divider
local TAB_LEFT_SHAPE = wezterm.nerdfonts.ple_lower_right_triangle
local TAB_RIGHT_SHAPE = wezterm.nerdfonts.ple_upper_left_triangle

----------------------------------------------------
-- イベントハンドラ
----------------------------------------------------
-- タブバーにワークスペース名を表示
wezterm.on("update-right-status", function(window, _)
  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#daa4ff" } },
    { Text = " " .. window:active_workspace() .. "  " },
  }))
end)

-- タブタイトルを固定幅にパディング（色設定込み）
wezterm.on("format-tab-title", function(tab, _, _, _, _, _)
  local background = tab.is_active and "#9ddb23" or "#bfbdb5"
  local foreground = "#000000"
  local edge_background = "none"
  local edge_foreground = background

  local title = wezterm.truncate_right(tab.active_pane.title, TAB_WIDTH - 2)
  local pad = TAB_WIDTH - wezterm.column_width(title) - 2
  if pad > 0 then
    local left = math.floor(pad / 2)
    title = string.rep(" ", left) .. title .. string.rep(" ", pad - left)
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = TAB_LEFT_SHAPE },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },

    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = TAB_RIGHT_SHAPE },
  }
end)

-- フォントサイズトグル
wezterm.on("toggle-font-size", function(window, _)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = not overrides.font_size and 18.0 or nil
  window:set_config_overrides(overrides)
end)

return config
