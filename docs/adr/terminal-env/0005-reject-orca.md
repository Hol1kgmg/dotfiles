---
status: 'rejected'
date: '2026-10-17'
decision-makers: 'Hol1kgmg'
---

# Orca への移行を見送る

## Context and Problem Statement

[0004](./0004-switch-to-herdr.md) で WezTerm + herdr の構成に落ち着いた後、AI エージェント(Claude Code 等)を複数並行で動かす用途に特化した [stablyai/orca](https://github.com/stablyai/orca) への移行を検討した。Orca は Electron 製の AI エージェント用 IDE で、git worktree 単位の作業領域に内蔵ターミナル(xterm.js)・エディタ・diff・ブラウザを束ねる。導入する場合は WezTerm / herdr を併用せず、Orca 単体で運用する前提とした。

[0001](./0001-adopt-herdr.md) 以降、herdr / native / tmux の 3 モードを通じて「Prefix(Shift+Space)起点の 2 段階操作」を共通の操作体系として維持してきた。この使用感を Orca にそのまま移行できるかどうかが導入可否の分かれ目だった。

## Decision Drivers

- Prefix(Shift+Space)+ 1 キーの 2 段階操作体系を維持したい(3 モードで共通化してきた操作感を崩さない)
- 既存の Nix 宣言的管理パターン(Homebrew cask + home-manager の設定ファイル配置)に乗せたい
- WezTerm / herdr を捨てて Orca 単体に寄せること自体は許容する

## Considered Options

- Orca 単体へ移行し、Prefix 体系を捨てて 1 段チョード(修飾キー + 1 キー)体系に再設計する
- Orca 単体へ移行し、Karabiner-Elements 等の外部リマッパで Prefix レイヤを再現する
- Orca を見送り、WezTerm + herdr を継続する

## Decision Outcome

Orca への移行を見送り、WezTerm + herdr([0004](./0004-switch-to-herdr.md) の構成)を継続する。

理由: Orca のキーバインドは「修飾キー + 単一キー」および「修飾キーのダブルタップ(`DoubleTap+<修飾キー>`)」しか表現できず、VS Code の `ctrl+k ctrl+s` のような連続キー(chord)や leader/prefix の概念が存在しない。`src/shared/keybindings/parser.ts` はバインド文字列を `+` でのみ分割し、2 つ目のキートークンが現れた時点で無効と判定する。`matching.ts` にも 1 打鍵目を待ち受ける状態はない。GitHub Issue にも chord / leader の要望は見当たらなかった(2026-10-17 時点、v1.4.227)。

ターミナルや herdr を使わなくなること自体は許容できたが、Prefix キー管理の使用感をそのまま移行できない点が決定的だった。

### Consequences

- Good, because `home/modules/terminal/` と WezTerm キーバインド構成に変更が発生せず、0004 の運用モデルを維持できる
- Good, because Orca の設定の大半(フォント・シェル・テーマ等)は Electron userData 内の内部ストアに保存され GUI からしか変更できないため、宣言的管理に乗らない部分を抱え込むことを回避できた
- Neutral, because Orca が提供する worktree 単位のエージェント並行実行・session restore・diff / browser 統合といった利点は得られないまま残る
- Bad, because Prefix 体系を前提にする限り、VS Code 型の 1 段チョードしか持たないツールは今後も候補から外れる(選定時に chord / leader 対応の有無を先に確認する教訓として残す)

## Implementation Plan

このADRはrejected決定であり、コード変更は発生しない。

- **Affected paths**: `docs/adr/terminal-env/`(このADRファイルと`README.md`の一覧のみ)
- **Dependencies**: 変更なし。`home/modules/terminal/herdr.nix`、`home/modules/terminal/configs/wezterm/keybinds/` は現状維持
- **Patterns to follow**: 該当なし(コード変更なし)
- **Patterns to avoid**: Prefix 体系を外部キーリマッパで無理に再現しないこと(Orca 以外のアプリにも影響し、terminal-env の範囲を越える input-env 側の決定になるため)
- **Configuration**: 変更なし
- **Migration steps**: 該当なし(移行を行わないため)

### Verification

- [x] `docs/adr/terminal-env/0005-reject-orca.md` の status が `rejected` である
- [x] `docs/adr/terminal-env/README.md` の一覧に 0005 が追加されている
- [x] `home/modules/terminal/default.nix` で `herdr.nix` が有効なまま変更がない(herdr 構成の継続を確認)

## Pros and Cons of the Options

### Orca 単体へ移行し、1 段チョード体系に再設計する

Orca の全アクション(`terminal.splitRight` / `terminal.focusNextPane` / `tab.newTerminal` / `worktree.palette` 等)は `~/.orca/keybindings.json`(JSON、`version: 1`、`keybindings` + `platforms.darwin/linux/win32`)で remap 可能。herdr で Prefix を使わない操作(pane focus `Alt+Shift+HJKL`、tab 切替 `Alt+H/L`、`Ctrl+Tab`)はそのまま移せる。

- Good, because `home.file.".orca/keybindings.json"` で cmux と同じ方式の宣言的管理ができる
- Good, because Kitty keyboard protocol を advertise しており、TUI との修飾キー衝突は `terminal-first` ポリシーで調整できる
- Bad, because Prefix 配下の操作(新規タブ・分割・閉じる・リサイズ・コピーモード等)を全て 1 段チョードに割り直す必要があり、3 モードで共通化してきた操作感を失う
- Bad, because pane 分割は右・下の 2 方向のみで、herdr の 4 方向分割(`prefix+h/j/k/l`)に相当する操作がない
- Bad, because GUI からショートカットを変更すると Orca が `keybindings.json` に書き込むため、Nix store への read-only symlink と競合する

### Orca 単体へ移行し、外部リマッパで Prefix レイヤを再現する

Karabiner-Elements 等で「Shift+Space 後の 1 キーを Cmd 系チョードに変換」するレイヤを作る案。

- Good, because 見かけ上は Prefix 体系を維持できる
- Bad, because リマップが Orca 以外の全アプリに影響し、アプリ別の条件分岐が必要になる
- Bad, because terminal-env の範囲を越えて input-env 側に新たな管理対象(リマッパの設定)を増やすことになり、本来の目的(ターミナル環境の移行)に対して保守コストが見合わない

### Orca を見送り、WezTerm + herdr を継続する

- Good, because Prefix 体系・既存の宣言的管理・0004 の運用モデルを全て維持できる
- Neutral, because 0001 以来の見直しトリガー(ユーザー体験の悪化)は変わらず主観的な基準のまま残る
- Bad, because worktree 単位のエージェント並行運用という Orca の利点は得られない

## More Information

- 関連ADR: [0004-switch-to-herdr.md](./0004-switch-to-herdr.md)(現行構成)、[0001-adopt-herdr.md](./0001-adopt-herdr.md)(Prefix 体系の起点)
- 検討対象リポジトリ: [stablyai/orca](https://github.com/stablyai/orca)(MIT、v1.4.227、2026-10-16 時点)
- 調査時点での Orca の設定管理可否:
  - キーバインド: `~/.orca/keybindings.json`(ファイル管理可)
  - フォント・シェル・テーマ等: Electron userData(`~/Library/Application Support/Orca`)内の内部ストア(GUI 専用、ファイル管理不可)
  - repo 単位の設定: 各リポジトリに commit する `orca.yaml` / `.worktreeinclude`(dotfiles の管理対象外)
  - Homebrew: `brew install --cask stablyai/orca/orca`(tap `stablyai/orca` が必要、`auto_updates true`)
- 教訓: 今後ターミナル環境のツールを検討する際は、連続キー(chord)または leader/prefix キーの対応有無を候補選定の最初のフィルタとする。1 段チョードしか持たないツールは Prefix 体系と両立しない
