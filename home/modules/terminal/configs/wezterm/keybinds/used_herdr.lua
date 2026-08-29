-- ============================================================
-- herdr 運用モデル (詳細: 同ディレクトリの README.md)
-- ============================================================
--
-- ※ WezTerm workspace は封印(操作キーバインドを空で設定)
-- ※ WezTerm タブも基本 1 枚運用 (Cmd+T で追加は可能だが常用しない)
--
--   WezTerm window(1workspace-1tab 運用)
--   └─┬─── アクティブスペース (herdr が担当) ───────────
--     └── herdr セッション
--         ├── herdr タブ (= 作業単位)
--         │   ├── ペイン
--         │   └── ペイン
--         └── herdr タブ
--             └── ペイン
--
-- ## アクティブスペース内の操作 (Prefix = Shift+Space)
--   Prefix 配下のキーは herdr 本体の設定 (このファイルでは Prefix の転送のみ実装)
--   | 操作                | キー                        |
--   |----------------------|-----------------------------|
--   | 新規タブ(作業単位)   | Prefix+T                    |
--   | タブを閉じる         | Prefix+W                    |
--   | タブ切り替え         | Alt+H / Alt+L               |
--   | 新規 workspace       | Prefix+Shift+T              |
--   | workspace 切り替え   | Ctrl+Tab / Ctrl+Shift+Tab   |
--   | ペイン分割           | Prefix+H/J/K/L              |
--   | ペイン移動           | Alt+Shift+H/J/K/L           |
--   | ペインを閉じる       | Prefix+X                    |
--   | リサイズモード       | Prefix+R                    |
--   | コピーモード         | Prefix+V                    |
--
-- ## モード固有の操作 (herdr / native と対応するキーが存在しないもの)
--   workspace を閉じる : Prefix+Shift+D
--   サイドバー         : Cmd+S
--
-- ## KKP (Kitty Keyboard Protocol) シーケンスによる herdr への転送
--   | キー              | シーケンス      | herdr 側の機能 |
--   |--------------------|-----------------|-----------------|
--   | Shift+Space        | \x1b[32;2u      | prefix          |
--   | Cmd+S              | \x1b[115;9u     | サイドバートグル |
--   | Ctrl+Tab           | \x1b[9;5u       | 次の workspace  |
--   | Ctrl+Shift+Tab     | \x1b[9;6u       | 前の workspace  |
--
-- このほか Tab / Shift+Tab は「WezTerm タブが複数あれば切り替え、単独ならそのままキーを送信」
-- という動作 (基本 1 枚運用のため、通常はそのまま送信される)。
--
-- WezTerm workspace の操作キーは意図的に割り当てない (Ctrl+Tab の転送により、WezTerm デフォルトの
-- タブ切り替えも上書きされる)。
-- ============================================================

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
	mode = "herdr",

	keys = {
		-- tmux系マルチプレクサのprefixとしてshift+spaceをKKPシーケンスで送信
		{ key = "Space", mods = "SHIFT",   action = wezterm.action.SendString("\x1b[32;2u") },
		-- Cmd+S をKKPシーケンスとして転送 (herdrのsidebar toggleへ届けるため)
		{ key = "s",     mods = "SUPER",   action = wezterm.action.SendString("\x1b[115;9u") },
    -- Ctrl+Tab / Ctrl+Shift+Tab をKKPシーケンスとして転送(herdrのworkspace切り替えへ)
    -- WezTerm workspaceは意図的に未割り当て(デフォルトのタブ切り替えもここで上書き)
    { key = "Tab", mods = "CTRL",      action = wezterm.action.SendString("\x1b[9;5u") },
    { key = "Tab", mods = "CTRL|SHIFT",action = wezterm.action.SendString("\x1b[9;6u") },
		-- タブが複数あればnext/prev tab、単独ならそのまま送信
		{ key = "Tab",   mods = "",        action = wezterm.action_callback(tab_or_next) },
		{ key = "Tab",   mods = "SHIFT",   action = wezterm.action_callback(shift_tab_or_prev) },
	},

	key_tables = {},
}
