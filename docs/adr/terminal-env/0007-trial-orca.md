---
status: 'proposed'
date: '2026-10-20'
decision-makers: 'Hol1kgmg'
---

# Orca を Prefix なしの操作体系で試用する

## Context and Problem Statement

[0005](./0005-reject-orca.md) では、Orca のキーバインドが連続キー(chord)や leader/prefix を表現できず、Prefix(Shift+Space)起点の 2 段階操作を移行できないことを理由に導入を見送った。

その後、Prefix 体系を手放すことを許容したうえで Orca への移行を再検討した。Orca を使う場合は kitty / herdr を併用せず Orca 単体で運用する前提は 0005 と変わらない。論点は「Prefix なしで herdr の使用感をどこまで再現できるか」に移った。

調査は v1.4.232 のソース(`src/shared/keybindings/definitions-core-*.ts`)を正とした。ドキュメントではペイン分割が `Cmd+\` と書かれているが、実装の既定は `Cmd+D` / `Cmd+Shift+D` だった。

## Decision Drivers

- herdr で Prefix を使っていない操作(ペイン移動・タブ切替・workspace 切替・サイドバー)は同じキーのまま移す
- Prefix 配下の操作は一貫した規則で置き換え、覚え直しを最小にする
- キーバインドは既存の宣言的管理(Homebrew cask + home-manager のファイル配置)に乗せる
- kitty / herdr の設定は残し、いつでも戻れる状態で試用する

## Considered Options

- Orca を Prefix なしの 1 段チョード体系で試用する
- 0005 の決定を維持し、kitty + herdr を継続する

## Decision Outcome

Orca を kitty / herdr と並行導入し、Prefix なしの 1 段チョード体系で試用する。採否は試用後に本 ADR の status を `accepted` / `rejected` へ更新して確定する。

キーの置き換え規則は次の 2 つとする。

- herdr で Prefix を使わない操作は、同じキーをそのまま割り当てる
- `Prefix+キー` は `Cmd+Shift+キー` に置き換える。ただし T / W は Orca の既定の `Cmd+T` / `Cmd+W` が同じ意味のため `Cmd` のままにする

### Consequences

- Good, because ペイン移動(`Alt+Shift+HJKL`)・タブ切替(`Alt+H/L`)・workspace 切替(`Ctrl+Tab`)・サイドバー(`Cmd+S`)は herdr と同じキーで使える
- Good, because worktree 単位の作業領域・session restore・diff / エディタ / ブラウザの統合が得られる
- Neutral, because ペイン移動は方向指定ではなく前後の巡回になり、`H/K` と `L/J` は「前」「次」の近似になる
- Bad, because 左・上への分割、リサイズモード、コピーモード、`Ctrl+;` のフォントサイズトグルは Orca に相当機能がなく失われる
- Neutral, because ターミナルは kitty の画像プロトコル・SIXEL・iTerm2 方式の画像表示に既定で対応している。ただし PTY にピクセルサイズを渡していないため、`kitten icat` のように OS(TIOCGWINSZ)からピクセルサイズを読むツールは動かない(回避策は保留、More Information 参照)
- Bad, because フォント・シェル・テーマ等は Electron userData 内の設定ストアに保存され、GUI でしか変更できない
- Bad, because `keybindings.json` は Nix store への読み取り専用リンクのため、Orca の設定画面からショートカットを変更すると保存に失敗する。変更はリポジトリのファイルを直接編集する(cmux の settings.json と同じ制約)

## Implementation Plan

- **Affected paths**:
  - `nix-darwin/homebrew/taps.nix`(`stablyai/orca` を追加)
  - `nix-darwin/homebrew/cask/default.nix`(`"stablyai/orca/orca"` を追加)
  - `home/modules/terminal/orca.nix`(新規、`home.file.".orca/keybindings.json"` でファイル単位にリンク)
  - `home/modules/terminal/configs/orca/keybindings.json`(新規)
  - `home/modules/terminal/default.nix`(imports に `./orca.nix` を追加)
  - `home/modules/system/dock/default.nix`(Dock の kitty の右隣に Orca.app を追加)
  - `home/modules/system/fonts/default.nix`(`nerd-fonts.symbols-only` を追加。Orca の予備フォント列に含まれるアイコン専用フォントで、指定フォントにないアイコンを補う)
- **Dependencies**: kitty / herdr の設定は変更なし
- **Patterns to follow**: `kitty.nix` / `cmux.nix` と同じく home-manager による設定ファイル配置。`~/.orca` には worktree やエージェント状態も入るため、ディレクトリごとのリンクにはしない
- **Patterns to avoid**: 「閉じる」相当として `workspace.delete` を `Cmd+Shift+W` に割り当てないこと。Orca の削除は worktree のディレクトリとブランチまで消すため、確認ダイアログ付きの既定 `Cmd+Shift+Backspace` のまま残す
- **Configuration**: `keybindings.json` のみ。既定キーを残したい項目は配列に既定値も含める。空配列は既定キーの解除を意味する
- **Migration steps**:
  1. `sudo darwin-rebuild switch --flake .#default --impure` で Orca をインストール
  2. `home-manager switch --flake .#$(whoami) --impure` で keybindings.json を配置
  3. 初回起動時に Ghostty 設定の取り込みを行い、フォントとテーマを反映する(`~/.config/ghostty/config` は `ghostty.nix` で配置済み)
  4. Settings → Terminal で JIS キーボードの ¥ → \ 変換を確認する

### キー対応表

| 操作 | herdr / kitty | Orca | Orca のアクション |
|---|---|---|---|
| 前のペインへ移動 | `Alt+Shift+H` / `K` | 同じ | `terminal.focusPreviousPane` |
| 次のペインへ移動 | `Alt+Shift+L` / `J` | 同じ | `terminal.focusNextPane` |
| 右に分割 | `Prefix+L` | `Cmd+Shift+L` | `terminal.splitRight` |
| 下に分割 | `Prefix+J` | `Cmd+Shift+J` | `terminal.splitDown` |
| 左・上に分割 | `Prefix+H` / `K` | なし | 相当機能なし |
| ペインを閉じる | `Prefix+X` | `Cmd+Shift+X` | `terminal.closePane` |
| リサイズ | `Prefix+R` | なし | マウス操作のみ。`Cmd+Shift+Enter` のペイン最大化は利用可 |
| コピーモード | `Prefix+V` | なし | `Cmd+F` の検索とマウス選択で代用 |
| 前のタブ | `Alt+H` / `Alt+←` | 同じ | `tab.previousAllTypes` |
| 次のタブ | `Alt+L` / `Alt+→` | 同じ | `tab.nextAllTypes` |
| 新規タブ | `Prefix+T` | `Cmd+T` | `tab.newTerminal`(既定) |
| タブを閉じる | `Prefix+W` | `Cmd+W` | `tab.close`(既定) |
| 次・前の workspace | `Ctrl+Tab` / `Ctrl+Shift+Tab` | 同じ | `worktree.navigateDown` / `navigateUp` |
| 新規 workspace | `Prefix+Shift+T` | `Cmd+Shift+T` | `workspace.create`。cdi によるディレクトリ選択は作成画面のリポジトリ選択に置き換わる |
| workspace を閉じる | `Prefix+Shift+W` | 割り当てない | Patterns to avoid を参照 |
| N 番目の workspace | `Prefix+1〜9` | `Cmd+1〜9` | `workspace.selectByIndex`(既定) |
| サイドバー | `Cmd+S` | 同じ | `sidebar.left.toggle` |
| シェルのポップアップ | `Prefix+F` | `Cmd+Shift+F` | `floatingTerminal.toggle` |
| フォントサイズトグル | `Ctrl+;` | なし | Orca のズームは UI 全体にかかり、トグルもない |

上の割り当てのため、次の既定キーを解除する。

- `tab.previousRecent`(既定 `Ctrl+Tab`): workspace 切替に使うため
- `tab.reopenClosed`(既定 `Cmd+Shift+T`): workspace 作成に使うため
- `editor.save`(既定 `Cmd+S`): サイドバーに使うため。Orca のエディタは自動保存のため実害はない
- `sidebar.search.toggle`(既定 `Cmd+Shift+F`): フローティングターミナルに使うため。ファイル名検索は `Cmd+P` で残る
- `terminal.closePane` から既定の `Cmd+W` を外し、`Cmd+W` をタブを閉じる専用にする

### Verification

- [x] `brew list --cask` に orca があり、Orca が起動する
- [x] `~/.orca/keybindings.json` がリポジトリのファイルへのリンクになっている
- [ ] Orca の再起動後、Symbols Nerd Font によってアイコンの欠けが解消している
- [ ] 起動時に keybindings.json の読み込みエラーや書き込みエラーが出ない(出た場合は activation でのコピー方式に切り替える)
- [ ] Settings → Shortcuts で上表の割り当てが反映され、競合の警告が出ていない
- [ ] ターミナル上で `Cmd+W` がペインではなくタブを閉じる(別スコープの同一キーの優先順位を確認)
- [ ] `Alt+H/L`・`Alt+Shift+HJKL`・`Ctrl+Tab` がターミナルフォーカス中も Orca 側で処理される
- [ ] 日本語入力(macism)で preedit が崩れず、Ctrl+I のカタカナ変換が描画に反映される([0006](./0006-trial-kitty.md) と同じ確認項目)

## Pros and Cons of the Options

### Orca を Prefix なしの 1 段チョード体系で試用する

- Good, because Prefix 以外の herdr の操作はほぼ同じキーで再現できる
- Good, because AI エージェントの並行運用に必要な機能(worktree 分離、エージェント状態表示、diff レビュー)が 1 つのアプリに揃う
- Bad, because Prefix を前提にした 3 モード共通の操作体系([0001](./0001-adopt-herdr.md) 以降)を捨てることになる
- Bad, because Electron アプリのため、kitty + herdr より描画やメモリの負荷が高い可能性がある

### 0005 の決定を維持し、kitty + herdr を継続する

- Good, because 変更が発生しない
- Bad, because worktree 単位のエージェント並行運用という Orca の利点は得られない

## More Information

- 関連ADR: [0005-reject-orca.md](./0005-reject-orca.md)(Prefix 非対応を理由に見送った決定、本 ADR により superseded)、[0004-switch-to-herdr.md](./0004-switch-to-herdr.md)(herdr の運用モデル)、[0006-trial-kitty.md](./0006-trial-kitty.md)(並行試用中のターミナル)
- 検討対象リポジトリ: [stablyai/orca](https://github.com/stablyai/orca)(v1.4.232、2026-10-20 時点)
- キーバインドの制約(v1.4.232 のソースで確認):
  - 修飾キーを含まないバインドは登録できない。Shift だけの組み合わせも不可(`terminal.switchInputSource` のみ例外)
  - 既定の Terminal shortcut policy は `orca-first` で、割り当てたキーはターミナル内の TUI に届かない。herdr も同じキーを奪っていたため使用感は変わらない
  - 競合判定は同じスコープ内でのみ行われ、別スコープの同一キーは警告されない
- フォント(v1.4.232 のソースで確認):
  - Orca はフォント一覧を `system_profiler SPFontsDataType` から作るため、home-manager が `~/Library/Fonts/HomeManager` に配置したフォント(PlemolJP Console NF 等)も選択肢に出る。一覧は起動時に一度だけ読み込まれるため、フォント追加後は Orca の再起動が必要
  - フォント欄の値は 1 つのフォント名として引用符で囲まれ、カンマ区切りで予備フォントを指定できない
  - 指定フォントにない文字は、Orca 側で固定の予備フォント列(SF Mono、Menlo、Orca 同梱のアイコン用フォント、Symbols Nerd Font Mono、MesloLGS Nerd Font、JetBrainsMono Nerd Font、Hack Nerd Font の順)で補われる。このため予備フォント列に含まれる Symbols Nerd Font Mono を入れるだけで、Orca の設定を変えずにアイコンを補える
- 画像表示(v1.4.232 のソースで確認):
  - Settings → Terminal → Inline Images(既定オン)で、kitty の画像プロトコル・SIXEL・iTerm2 方式に対応する。kitty の画像プロトコルは直接送信とファイルパス指定、Unicode プレースホルダに対応し、一時ファイル・共有メモリ経由の送信は非対応
  - シェルには `TERM=xterm-256color`、`TERM_PROGRAM=Orca`、`ORCA_IMAGE_PROTOCOL=kitty` が渡される。`TERM=xterm-kitty` で判定するツールは画像表示を自動で有効にしない
  - `kitten icat` は TIOCGWINSZ のピクセルサイズが 0 のため「Terminal does not support reporting screen sizes in pixels」で失敗する。CSI 14t で問い合わせた値を `--use-window-size` に渡す zsh 関数で回避できる見込みだが、動作未確認のため導入は保留
- 見直しトリガー: 失われた操作(左・上分割、リサイズ、コピーモード、フォントトグル)の不便さが worktree 統合の利点を上回ったと判断した時点
