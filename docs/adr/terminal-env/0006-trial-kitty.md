---
status: 'proposed'
date: '2026-10-17'
decision-makers: 'Hol1kgmg'
---

# kitty を WezTerm と並行して試用する

## Context and Problem Statement

[0004](./0004-switch-to-herdr.md) の WezTerm + herdr 構成を継続する中で、WezTerm に次の 2 つの問題を抱えていた。

- **IME の描画不具合**: 日本語入力中に Ctrl+I でカタカナへ変換しても、WezTerm 上の preedit 描画がひらがなのまま更新されない。確定するまで変換結果を目視できず、日本語入力の体験を損なっている
- **stable 版の更新停滞**: WezTerm の stable リリースは 2024 年 2 月を最後に数年止まっており、上記のような不具合の修正を stable で受け取れる見込みが立たない。nightly は Nix の macOS ビルドに問題があり(`nix-darwin/homebrew/cask/default.nix` のコメント参照)、Homebrew 経由でも常用しづらい

この 2 点を解消するため、ターミナルエミュレータ自体を [kitty](https://sw.kovidgoyal.net/kitty/) へ移行できるかを検討した。
[0005](./0005-reject-orca.md) の教訓(Prefix 体系と両立するか)を最初のフィルタとして、WezTerm の設定一式(本体・keybinds 3 モード・plugin)を kitty で再現できるかを評価した。

評価の結果、**herdr / tmux を前提とするモードでは WezTerm が担う仕事はキー転送とタブ操作のみで、kitty へ完全に移植できる**。一方、WezTerm ネイティブ多重化(`wezterm_native.lua`)が依存するコピーモード・workspace は kitty に同等機能がない。

## Decision Drivers

- 日本語 IME の preedit(Ctrl+I のカタカナ変換を含む)が正しく描画される
- 継続的にリリースされているターミナルを使い、不具合修正を安定版で受け取れる
- Prefix(Shift+Space)+ 1 キーの操作体系を維持する
- herdr が使う KKP(Kitty Keyboard Protocol)の転送が確実に届く
- 既存の宣言的管理(Homebrew cask + home-manager の設定ファイル配置)に乗る
- WezTerm の設定は削除せず、いつでも戻れる状態で試用する

## Considered Options

- kitty を WezTerm と並行導入し、herdr モード相当の設定のみで試用する
- kitty へ全面移行し、native モード相当(コピーモード等)も kitten で再現する
- kitty を見送り、WezTerm + herdr を継続する

## Decision Outcome

kitty を WezTerm と並行導入し、herdr モード相当の設定のみで試用する。採否は試用後に本 ADR の status を `accepted` / `rejected` へ更新して確定する。

### Consequences

- Good, because kitty は KKP の本家であり、herdr への Shift+Space / Cmd+S / Ctrl+Tab 転送が WezTerm と同じ `send_text` 1 行ずつで書ける
- Good, because Lua と plugin がなくなり、設定が `kitty.conf` 1 ファイルに収まる
- Good, because WezTerm 設定を残すため、試用中にいつでも戻れる
- Neutral, because Ctrl+; のフォントサイズトグルは kitty の `change_font_size` では往復できないため、現在値を読んで切り替えるカスタム kitten(`toggle_font_size.py`)で実現した。Neovim はターミナルのリサイズ(SIGWINCH)に追従するだけなので、Neovim 側の変更は不要
- Bad, because native モードへ戻す選択肢は kitty 上では成立しない(下記参照)。native を復活させる場合は WezTerm に戻る前提になる
- Bad, because 設定の自動リロードがなく、Ctrl+Shift+F5 での手動リロードになる

## Implementation Plan

- **Affected paths**:
  - `home/modules/terminal/configs/kitty/kitty.conf`(新規)
  - `home/modules/terminal/configs/kitty/toggle_font_size.py`(新規、フォントトグル kitten)
  - `home/modules/terminal/kitty.nix`(新規、wezterm.nix と同様にディレクトリごと配置)
  - `home/modules/terminal/default.nix`(imports に `./kitty.nix` 追加)
  - `nix-darwin/homebrew/cask/default.nix`(`"kitty"` 追加。`"wezterm"` は残す)
  - `home/modules/system/dock/default.nix`(Dock の登録を WezTerm.app から kitty.app へ差し替え)
- **Dependencies**: herdr 側(`configs/herdr/config.toml`)は変更なし。WezTerm 設定(`configs/wezterm/`)は変更なし
- **Patterns to follow**: `ghostty.nix` と同じ `xdg.configFile` による配置。キーは `used_herdr.lua` の KKP シーケンスをそのまま流用
- **Patterns to avoid**: native モード相当のキー(コピーモード・workspace・リサイズモード)を kitty.conf に持ち込まない。`clear_all_shortcuts yes` で kitty のデフォルト(ctrl+tab = next_tab 等)との衝突を避ける
- **Configuration**: `kitty.conf` のみ。Nix 側に新しいオプションは増やさない
- **Migration steps**:
  1. `sudo darwin-rebuild switch --flake .#default --impure` で kitty をインストール
  2. `home-manager switch --flake .#$(whoami) --impure` で kitty.conf を配置
  3. kitty 上で herdr を起動し、Prefix / Cmd+S / Ctrl+Tab / Ctrl+; が届くことを確認
  4. 日本語 IME(macism)の挙動を確認する。kitty には WezTerm の `ime_preedit_rendering` に相当する調整項目がない

### Verification

- [ ] kitty 上で Shift+Space が herdr の prefix として機能する
- [ ] Cmd+S でサイドバー、Ctrl+Tab / Ctrl+Shift+Tab で workspace 切替が動く
- [ ] Ctrl+; でフォント 18、もう一度押すと 13 に戻り、Neovim が再レイアウトされる
- [ ] 日本語入力(macism)で preedit が崩れず、Ctrl+I のカタカナ変換が描画に反映される(移行動機の解消確認)
- [ ] WezTerm が従来通り起動・動作する(並行導入による影響なし)

## Pros and Cons of the Options

### kitty を並行導入し、herdr モード相当のみで試用する

- Good, because WezTerm 側の仕事(4 キーの KKP 転送・Cmd+T)は全て `map` で直訳できる
- Good, because tmux モードへ切り替える場合も `next_tab` / `previous_tab` と `launch --type=tab zsh -ic "cdi; exec tmux"` で同様に書ける
- Neutral, because フォントトグルだけは `map` で書けず、Python の kitten が 1 ファイル増える

### kitty へ全面移行し、native モード相当も再現する

- Good, because WezTerm を完全に捨てられる
- Bad, because kitty には組み込みのコピーモード・検索モードがなく、`show_scrollback` + nvim や kitty-scrollback.nvim で代替する必要がある
- Bad, because workspace の概念がなく、OS ウィンドウかタブで代用するしかない
- Neutral, because Leader はキーチョード(`map shift+space>t`)、リサイズモードはキーボードモード(`map --new-mode`)で再現できるが、タイムアウト等の細部は一致しない

### kitty を見送り、WezTerm + herdr を継続する

- Good, because 変更が発生しない
- Bad, because IME の preedit 描画不具合が残り、stable 版の更新停滞により修正の見込みも立たない
- Bad, because Lua 設定と plugin の保守が残り、kitty の KKP ネイティブ対応の恩恵を受けられない

## More Information

- 関連ADR: [0004-switch-to-herdr.md](./0004-switch-to-herdr.md)(現行の運用モデル)、[0005-reject-orca.md](./0005-reject-orca.md)(Prefix 体系を選定フィルタとする教訓)
- WezTerm との対応表(herdr モード):

  | WezTerm | kitty |
  |---|---|
  | `window_decorations = "RESIZE"` | `hide_window_decorations titlebar-only` |
  | `window_background_opacity` / `macos_window_background_blur` | `background_opacity` / `background_blur` |
  | `enable_tab_bar = false` | `tab_bar_style hidden` |
  | 前景色 / ANSI 白(デフォルト silver `#c0c0c0`) | kitty デフォルトは `#dddddd` / `#e5e5e5` と明るいため `foreground` / `color7` を `#c0c0c0` に明示 |
  | 文字の太さ(FreeType、太らせ処理なし) | kitty の `text_composition_strategy platform` は macOS でガンマ 1.7 + コントラスト 30% を適用し太く見えるため `1.0 0` で太らせ処理を切る |
  | `SendString("\x1b[32;2u")` | `send_text all \x1b[32;2u` |
  | `spawn_tab` + `set_title("tab")` | `launch --type=tab --tab-title tab` |
  | `EmitEvent("toggle-font-size")` | `kitten toggle_font_size.py`(`os_window_font_size` で現在値を読み `set_font_size` / `restore_font_size`) |
  | `DisableDefaultAssignment`(Ctrl+Shift+L) | `clear_all_shortcuts yes` |
  | `automatically_reload_config` | なし(Cmd+R に `load_config_file` を割り当て) |
  | macOS デフォルトの Cmd 系(Q / W / N / H / M / 1〜9 / Shift+[ ] / = - 0 / K / R) | `clear_all_shortcuts yes` で消えるため同じキーで明示的に `map`。Cmd+F(検索)は kitty に相当機能がなく対象外 |
