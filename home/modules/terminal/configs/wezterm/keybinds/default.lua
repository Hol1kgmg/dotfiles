-- ============================================================
-- キーバインド構成 (詳細: 同ディレクトリの README.md)
-- ============================================================
--
-- ## アクティブスペース運用の方針
--   アクティブスペース = セクション(workspace)・タブ・ペインを束ねる作業領域
--   操作キーは両モードで同じ体系に統一する (Prefix = Shift+Space)
--     マルチプレクサあり (used_herdr)      : herdr が相当 (WezTerm workspace は未使用)
--     マルチプレクサなし (wezterm_native)  : WezTerm が相当 (workspace = プロジェクト単位)
--   モード切り替えは下記 multiplexer の require を差し替える
-- ============================================================

local wezterm = require("wezterm")
local act = wezterm.action

-- マルチプレクサに関わらず常に有効なキーバインド
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

-- マルチプレクサ切り替え (どちらか1行を有効にする)
-- local multiplexer = require("keybinds.used_herdr")       -- herdr など tmux 系マルチプレクサ使用時
local multiplexer = require("keybinds.wezterm_native") -- WezTerm ネイティブ多重化に戻す場合

local merged_keys = {}
for _, k in ipairs(multiplexer.keys) do merged_keys[#merged_keys + 1] = k end
for _, k in ipairs(common_keys)      do merged_keys[#merged_keys + 1] = k end

return {
	leader     = multiplexer.leader,
	keys       = merged_keys,
	key_tables = multiplexer.key_tables,
}
