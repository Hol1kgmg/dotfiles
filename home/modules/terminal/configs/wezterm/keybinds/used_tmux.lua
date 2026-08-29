-- ============================================================
-- tmux 運用モデル (詳細: 同ディレクトリの README.md)
-- ============================================================
--
-- ※ WezTerm workspace は常に単一のみ起動 (複数作成・切り替えはしない) → これがアクティブスペースに相当
-- ※ WezTerm タブは複数枚運用が前提 (1タブ = 1 tmux session)
--
--   WezTerm window
--   └─┬─── アクティブスペース (WezTerm workspace が担当、単一のみ) ───────────
--     └── WezTerm タブ (= tmux session、複数) ─── Ctrl+Tab/Ctrl+Shift+Tab で切替
--         └── tmux window (= 作業単位)
--             └── tmux pane
--
-- ## アクティブスペース内の操作 (Prefix = Shift+Space)
--   Prefix 配下のキーは tmux.conf 側の設定 (このファイルでは Prefix の転送のみ実装)
--   | 操作                | キー                        |
--   |----------------------|-----------------------------|
--   | 新規タブ(作業単位)   | Prefix+T (tmux window)      |
--   | タブを閉じる         | Prefix+W                    |
--   | タブ切り替え         | Alt+H / Alt+L               |
--   | 新規 workspace       | Cmd+T (WezTermネイティブタブ = 新規 tmux session) |
--   | workspace 切り替え   | Ctrl+Tab / Ctrl+Shift+Tab   |
--   | ペイン分割           | Prefix+H/J/K/L              |
--   | ペイン移動           | Alt+Shift+H/J/K/L           |
--   | ペインを閉じる       | Prefix+X                    |
--   | リサイズモード       | Prefix+R                    |
--   | コピーモード         | Prefix+V                    |
--
-- ## KKP (CSI u) シーケンスによる tmux への転送
--   tmux の prefix として届ける必要のあるキーのみ転送する:
--   | キー         | シーケンス | tmux 側の機能 |
--   |--------------|------------|----------------|
--   | Shift+Space  | \x1b[32;2u | prefix (tmux.conf 側で set -g prefix S-Space / set -s extended-keys on) |
--
-- Prefix 以降のキー (t/w/h/j/k/l/x/r/v/b/p 等) は WezTerm からは素通しされ、
-- tmux 自身が「prefix 待機状態」として解釈する (実際のバインドは
-- home/modules/terminal/configs/tmux/tmux.conf 側で定義)。
--
-- Ctrl+Tab / Ctrl+Shift+Tab は tmux へは転送せず、WezTerm ネイティブの ActivateTabRelative で
-- タブ (= tmux session) を切り替える。
--
-- WezTerm 自体の操作 (新規タブ・タブを閉じる) は Prefix 配下ではなく Cmd+T / Cmd+W を使う
-- (Prefix 配下は全て tmux への転送専用のため)。
--
-- Cmd+T は common_keys の汎用「空タブを開く」を上書きし、cdi でディレクトリを選んでから
-- そのディレクトリで tmux を起動する (= 新規タブ即新規 tmux session として使えるようにする)。
-- ============================================================

local wezterm = require("wezterm")
local act = wezterm.action

-- 対話シェル経由でコマンドを実行するargs (cdi等、対話シェルの関数定義が必要なコマンド用)
local function interactive_shell(cmd)
	return { "/bin/zsh", "-i", "-c", cmd }
end

return {
	mode = "tmux",

	keys = {
		-- prefixを伴う操作は全てtmux側の責務: Shift+SpaceをKKPシーケンスで送信するだけでよい
		-- (tmux.conf側で prefix = S-Space, 後続のキーは通常入力としてそのままtmuxへ届く)
		{ key = "Space", mods = "SHIFT", action = wezterm.action.SendString("\x1b[32;2u") },

		-- WezTerm tab = tmux session = workspace のため、タブ切替はWezTermネイティブ機能を使用
		{ key = "Tab", mods = "CTRL",       action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

		-- 新規タブ = 新規 tmux session (cdi でディレクトリ選択後、そのまま tmux を起動)
		{
			key = "t",
			mods = "SUPER",
			action = wezterm.action_callback(function(window, _)
				local tab, _, _ = window:mux_window():spawn_tab({ args = interactive_shell("cdi; exec tmux") })
				tab:set_title("tab")
			end),
		},
	},

	key_tables = {},
}
