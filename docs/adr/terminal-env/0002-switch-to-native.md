---
status: 'superseded by [0003-switch-to-tmux.md](./0003-switch-to-tmux.md)'
date: 2026-08-29
decision-makers: 'Hol1kgmg'
---

# WezTerm ネイティブ多重化へ切り替える

## Context and Problem Statement

[0001-adopt-herdr.md](./0001-adopt-herdr.md) で herdr を試験導入していたが、herdr を外部(herdr の管理外のシェル/セッション)から起動する際に環境変数 `HERDR_ENV=1` が残留し、herdr が起動できない問題が発生した。

この問題は herdr の既知 issue と類似するパターンである:

- #2134 (CLOSED) — tmux サーバーのグローバル環境に `HERDR_ENV=1` が漏れ残り、無関係なセッションで nested-launch ガードが誤爆して起動拒否になる。修正 PR #2137(`fix: ignore leaked herdr env inside tmux for nested-launch guard`)でクローズ済み
- #2135 (CLOSED) — 同根、プレーンな tmux セッションでの誤検知
- #2211 (CLOSED) — Windows→WSL 間で空の `HERDR_SESSION` が WSLENV 経由で漏れ継承し、herdr(`--help` 含む)が一切起動不能になる

自環境固有の問題か herdr 共通の問題かの切り分けが困難であり、問題が落ち着くまで herdr から距離を置く必要があった。

また、元々「ターミナルマルチプレクサという作業環境に依存するツールをできるだけ増やさない」という方針があり、この時点で tmux はまだ選択肢に入っていなかった。

## Decision

herdr を無効化し、WezTerm ネイティブ多重化(追加ツール不要、WezTerm 自身が1プロセスでアクティブスペースを担当)へ切り替える。

- [`home/modules/terminal/configs/wezterm/keybinds/README.md`](/home/modules/terminal/configs/wezterm/keybinds/README.md) に記載のアクティブスペース運用方針(Prefix = `Shift+Space`、新規タブ/workspace/ペイン分割などの操作体系)は維持する
- AIエージェント運用を加味したユーザー体験の比較検討は対象外(non-goal)とする

## Consequences

- Good, because 環境依存の外部ツール(herdr)を切り離すことで、`HERDR_ENV` 残留による起動不能問題を回避できる
- Good, because WezTerm 自身のみで完結するため、環境依存ツールを増やさない方針に合致する
- Bad, because AIエージェントをターミナル内で高性能に稼働させるという [0001](./0001-adopt-herdr.md) の当初目的は native では未検証のまま棚上げになる
- Bad, because herdr 側の問題が解消されたかどうかを追跡する仕組みがなく、再導入判断は都度手動での確認に依存する

## Implementation Plan

- **Affected paths**:
  - `home/modules/terminal/configs/wezterm/keybinds/used_herdr.lua`(無効化・以後未使用)
  - `home/modules/terminal/configs/wezterm/keybinds/wezterm_native.lua`(追加)
  - `home/modules/terminal/configs/wezterm/keybinds/default.lua`(multiplexer require を `used_herdr` → `wezterm_native` に差し替え)
  - `home/modules/terminal/herdr.nix`(無効化)
- **Dependencies**: herdr の依存を削除(または無効化)
- **Patterns to follow**: `default.lua` の `multiplexer` require 差し替え方式(3モード共通のエントリポイント構成)は [0001](./0001-adopt-herdr.md) から変更しない
- **Patterns to avoid**: herdr 固有のキーバインドやワークアラウンドを `wezterm_native.lua` に持ち込まない

### Verification

- [ ] `default.lua` の multiplexer require が `wezterm_native` になっている
- [ ] `herdr.nix` が無効化されている(herdr がインストールされない)
- [ ] README.md に記載のアクティブスペース運用方針(Prefix操作体系)が native モードでも維持されている

## Alternatives Considered

- tmux への切替: この時点ではまだ選択肢として検討していなかった(環境依存ツールを増やさない方針もあり、まず一番シンプルな native に戻ることを優先した)

## More Information

- 見直しトリガー: ユーザー体験の悪化があれば切り替えを検討する(具体的な定量基準は未定義)
- 先行する決定: [0001-adopt-herdr.md](./0001-adopt-herdr.md)(このADRにより Superseded)
- 後続の決定: [0003-switch-to-tmux.md](./0003-switch-to-tmux.md)
