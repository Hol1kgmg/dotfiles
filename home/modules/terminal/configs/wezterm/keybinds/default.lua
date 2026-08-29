-- ============================================================
-- キーバインド構成 エントリポイント (詳細: 同ディレクトリの README.md)
-- ============================================================
--
-- 3モード (herdr / tmux / native) 共通で Prefix (= Shift+Space) の操作体系に統一する。
-- モード切り替えは下記 multiplexer の require を差し替える (いずれか1行を有効にする)。
-- ============================================================

local wezterm = require("wezterm")
local act = wezterm.action

-- マルチプレクサに関わらず常に有効なキーバインド (multiplexer.keys に同じキーがあれば、そちらが優先される)
local common_keys = {
	-- Zenモードフォントサイズトグル (Neovimから呼び出し用)
	{ key = ";", mods = "CTRL", action = act.EmitEvent("toggle-font-size") },

	-- デバッグオーバーレイのデフォルト割り当てを無効化 (ctrl+shift+l を別用途で使うため)
	{ key = "L", mods = "CTRL|SHIFT", action = act.DisableDefaultAssignment },

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

-- マルチプレクサ切り替え (いずれか1行を有効にする)
-- local multiplexer = require("keybinds.used_herdr")       -- herdr 使用時
local multiplexer = require("keybinds.used_tmux")      -- tmux 使用時
-- local multiplexer = require("keybinds.wezterm_native") -- WezTerm ネイティブ多重化に戻す場合

-- multiplexer.keys を後に重ねることで、common_keys と同じキーは multiplexer 側の定義で上書きされる
local merged_keys = {}
for _, k in ipairs(common_keys)      do merged_keys[#merged_keys + 1] = k end
for _, k in ipairs(multiplexer.keys) do merged_keys[#merged_keys + 1] = k end

return {
	mode       = multiplexer.mode,
	leader     = multiplexer.leader,
	keys       = merged_keys,
	key_tables = multiplexer.key_tables,
}
