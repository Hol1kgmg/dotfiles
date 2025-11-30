local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タブを隠れて見えなくする
config.show_tabs_in_tab_bar = false
----------------------------------
----- タブのデザイン(見えないので適応されない)
----------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = false
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { "#000000" },
}
-- タブバーの透明度(0.0-1.0)
config.window_background_opacity = 0.8

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
-- config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"
	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-------------------------------------------------
--- font
-------------------------------------------------

-- 日本語IME入力対応のフォント設定
config.font = wezterm.font_with_fallback({
	-- メインフォント（英数字・記号用）
	{
		family = "JetBrains Mono", -- WezTermビルトインフォント
		weight = "Regular",
		-- stretch = "Normal",
		-- style = "Normal",
	},
	-- 日本語フォント（文字化け対策）
	{
		family = "Hiragino Kaku Gothic ProN", -- macOS標準日本語フォント
		weight = "Regular",
		-- stretch = "Normal",
		-- style = "Normal",
	},
})

config.font_size = 12.0
config.line_height = 1.2
-- config.cell_width = 1.0 -- セル幅を調整

-- 文字幅とUnicode処理の設定
-- config.unicode_version = 14
-- config.treat_east_asian_ambiguous_width_as_wide = true

-- IME設定（日本語入力改善）
-- config.use_ime = true
-- config.ime_preedit_rendering = "Builtin"

-- 文字レンダリング設定
-- config.freetype_load_target = "Normal"
-- config.freetype_render_target = "Normal"
----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = false  -- デフォルトキーバインドを有効化
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

----------------------------------------------------
----- 文字の設定
-------------------------------------------------------
-- config.enable_wayland = false

return config
