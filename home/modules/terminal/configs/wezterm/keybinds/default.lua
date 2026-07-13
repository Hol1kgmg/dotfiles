-- ============================================================
-- キーバインド構成メモ
-- ============================================================
--
-- ## モード切り替え
--   used_tmux.lua      : herdr など tmux 系マルチプレクサ使用時
--   wezterm_native.lua : WezTerm ネイティブ多重化使用時
--
-- ## 運用モデル
--
--   [マルチプレクサあり (used_tmux)]
--
--     WezTerm window
--     └── WezTerm タブ (new window 相当、滅多に使わない)
--         └── マルチプレクサ セッション
--             ├── マルチプレクサ タブ (= 作業単位)
--             │   ├── ペイン
--             │   └── ペイン
--             └── マルチプレクサ タブ
--                 └── ペイン
--
--   [マルチプレクサなし (wezterm_native)]
--
--     WezTerm window
--     └── WezTerm workspace (= プロジェクト単位)
--         └── WezTerm タブ (= 作業単位)
--             ├── WezTerm ペイン
--             └── WezTerm ペイン
--
-- ## Prefix / Leader
--   Shift+Space で固定
--   マルチプレクサあり : WezTerm が KKP シーケンスに変換してマルチプレクサへ転送
--   マルチプレクサなし : WezTerm の Leader キーとして直接使用
--
--   タブ切り替え : Alt+H / Alt+L
--   新規タブ     : Cmd+T (タイトル "tab" 固定) ※common_keys
--   workspace・ペイン操作 : wezterm_native 側で定義
--
-- ## ペイン (モードによって異なる)
--   [herdr 使用時]
--     WezTerm 側ではペイン操作キーを持たない
--     分割・移動・リサイズはすべて herdr が担当 (prefix+hjkl など)
--
--   [wezterm_native 使用時]
--     分割    : Leader+H/J/K/L
--     移動    : Alt+Shift+H/J/K/L
--     リサイズ: Leader+R → hjkl (Escape で終了)
--     コピー  : Leader+V
--
-- ============================================================

local wezterm = require("wezterm")
local act = wezterm.action

-- マルチプレクサに関わらず常に有効なキーバインド
local common_keys = {
	-- Zenモードフォントサイズトグル (Neovimから呼び出し用)
	{ key = ";", mods = "CTRL", action = act.EmitEvent("toggle-font-size") },

	-- 新しいタブ ("tab" で固定命名)
	{
		key = "t",
		mods = "SUPER",
		action = wezterm.action_callback(function(window, _)
			local tab, _, _ = window:mux_window():spawn_tab({})
			tab:set_title("tab")
		end),
	},
}

-- マルチプレクサ切り替え (どちらか1行を有効にする)
local multiplexer = require("keybinds.used_tmux")        -- herdr など tmux 系マルチプレクサ使用時
-- local multiplexer = require("keybinds.wezterm_native") -- WezTerm ネイティブ多重化に戻す場合

local merged_keys = {}
for _, k in ipairs(multiplexer.keys) do merged_keys[#merged_keys + 1] = k end
for _, k in ipairs(common_keys)      do merged_keys[#merged_keys + 1] = k end

return {
	leader     = multiplexer.leader,
	keys       = merged_keys,
	key_tables = multiplexer.key_tables,
}
