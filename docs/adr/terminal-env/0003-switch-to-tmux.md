---
status: 'accepted'
date: 2026-08-29
decision-makers: 'Hol1kgmg'
---

# tmux へ切り替える

## Context and Problem Statement

[0002-switch-to-native.md](./0002-switch-to-native.md) で WezTerm ネイティブ多重化(1プロセスがアクティブスペースを担当する方式)へ切り替えていたが、以下の問題が発生した。

- workspace の影響が同一プロセス全体に及ぶため、新規に WezTerm ウィンドウを開いて一方の workspace を切り替えると、もう一方のウィンドウにも影響が及んでしまう
- この影響を避けるために異なるプロセスとして new window を開くと、macOS 上では別アプリとして扱われ、Dock や `Cmd+Tab` のアプリ切り替えに WezTerm が複数表示されてしまう。ターミナル内の操作にとどまらず、OS レベルの操作性(ユーザー体験)まで悪化させた

herdr は [0001-adopt-herdr.md](./0001-adopt-herdr.md) 以来、`HERDR_ENV` 残留による起動不能問題が未解決のままであり、再検討の対象からは除外した。一方、これまで未導入だった tmux を試験的に採用することとした。

## Decision

WezTerm ネイティブ多重化を無効化し、tmux をアクティブスペース(セッション・タブ・ペインを束ねる作業領域)の担当として採用する。

- Prefix (`Shift+Space`) を WezTerm から KKP シーケンスに変換して tmux へ転送し、tmux 側で `prefix = S-Space` として解釈させる(tmux 3.2+ の `extended-keys` が必要)
- Prefix 配下のキーは全て tmux への転送専用として扱い、WezTerm 自体の操作(新規タブ・タブを閉じるなど)は Prefix ではなく `Cmd` を使う(`used_tmux.lua` 内の運用ルール)
- [`home/modules/terminal/configs/wezterm/keybinds/README.md`](/home/modules/terminal/configs/wezterm/keybinds/README.md) に記載のアクティブスペース運用方針は維持する
- herdr の問題解決状況の追跡、AIエージェント運用込みの評価は対象外(non-goal)とする

## Consequences

- Good, because workspace の影響範囲が tmux セッション単位に閉じ、複数 WezTerm ウィンドウ間の相互影響がなくなる
- Good, because プロセスを分ける必要がなくなり、macOS の Dock / `Cmd+Tab` に WezTerm が複数表示される問題を回避できる
- Bad, because tmux 3.2+ かつ `extended-keys` という前提条件が増え、環境要件が厳しくなる
- Bad, because Prefix 配下のキーが「tmux への転送専用」というモード固有の制約が生まれ、native/herdr との操作体系の一貫性が完全ではなくなる(WezTerm操作はCmdに退避)

## Implementation Plan

- **Affected paths**:
  - `home/modules/terminal/configs/wezterm/keybinds/wezterm_native.lua`(無効化・以後未使用)
  - `home/modules/terminal/configs/wezterm/keybinds/used_tmux.lua`(追加)
  - `home/modules/terminal/configs/wezterm/keybinds/default.lua`(multiplexer require を `wezterm_native` → `used_tmux` に差し替え)
  - `home/modules/terminal/tmux.nix`(追加、tmux 3.2+ を保証し `extended-keys` を設定)
- **Dependencies**: tmux 3.2+ を追加
- **Patterns to follow**: `default.lua` の `multiplexer` require 差し替え方式は [0001](./0001-adopt-herdr.md)/[0002](./0002-switch-to-native.md) から変更しない。Prefix配下キーは全てtmuxへの転送専用とし、WezTerm自体の操作はCmdを使う運用ルールに従う
- **Patterns to avoid**: native/herdr 固有のキーバインドやワークアラウンドを `used_tmux.lua` に持ち込まない

### Verification

- [ ] `default.lua` の multiplexer require が `used_tmux` になっている
- [ ] `tmux.nix` が有効化され、tmux 3.2+ かつ `extended-keys` が設定されている
- [ ] 複数 WezTerm ウィンドウ間で workspace 切替の影響が分離されている(native で発生していた相互影響が解消している)
- [ ] macOS の Dock / `Cmd+Tab` に WezTerm が複数表示されない

## Alternatives Considered

- herdr への再検討: `HERDR_ENV` 残留による起動不能問題([0002](./0002-switch-to-native.md) 参照)が未解決のため除外

## More Information

- 見直しトリガー: ユーザー体験の悪化があれば切り替えを検討する(具体的な定量基準は未定義)
- 先行する決定: [0002-switch-to-native.md](./0002-switch-to-native.md)(このADRにより Superseded)
- 次の検討候補:
  - herdr: `HERDR_ENV` 残留問題([0002](./0002-switch-to-native.md) 参照)が解決していれば再検討の余地あり
  - zellij: 未評価。tmux の代替候補としてメモ
