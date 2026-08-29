---
status: 'superseded by [0002-switch-to-native.md](./0002-switch-to-native.md)'
date: 2026-08-29
decision-makers: 'Hol1kgmg'
---

# herdr を WezTerm のマルチプレクサとして採用する

## Context and Problem Statement

WezTerm 上で AI エージェント(Claude Code 等)をターミナル内で稼働させる際、高いパフォーマンスで動作させたいという要求があった。当時、ターミナルマルチプレクサ(セッション・タブ・ペインを束ねる運用モデル)の詳細な運用方針はまだ詰めきれておらず、tmux や WezTerm ネイティブ多重化との比較検討は行っていない。まずは herdr を試験的に導入し、実運用の中で評価する方針とした。

## Decision

WezTerm のマルチプレクサとして herdr を採用する。

- Prefix (`Shift+Space`) を WezTerm から KKP シーケンスに変換し、herdr へ転送する
- herdr が「アクティブスペース」(セッション・タブ・ペインを束ねる作業領域)を担当する
- 他モード(tmux, WezTerm ネイティブ)との比較検討はスコープ外とし、まず herdr 単体を試す

問題が出るまで(具体的にはユーザー体験が悪化したと判断するまで)herdr を使い続ける。

## Consequences

- Good, because AI エージェントをターミナル内で高性能に稼働させるという当初の目的に対して、herdr を実運用で評価できる
- Bad, because 他候補(tmux, native)との比較を行っていないため、herdr が最適かどうかの裏付けがない
- Bad, because 「ユーザー体験の悪化」という主観的な基準でしか見直しトリガーを定義できておらず、定量的な判断基準がない

## Implementation Plan

- **Affected paths**:
  - `home/modules/terminal/configs/wezterm/keybinds/used_herdr.lua`
  - `home/modules/terminal/configs/wezterm/keybinds/default.lua`
  - `home/modules/terminal/herdr.nix`
- **Dependencies**: herdr (Nix 経由でインストール、`herdr.nix` で管理)
- **Patterns to follow**: `default.lua` の `multiplexer` require を差し替える方式(3モード共通のエントリポイント構成)に従う
- **Patterns to avoid**: tmux/native 固有のキーバインドを herdr 用ファイルに混在させない

### Verification

- [ ] `default.lua` の multiplexer require が `used_herdr` になっている
- [ ] `herdr.nix` が有効化され、herdr がインストール・起動されている
- [ ] Prefix (`Shift+Space`) で herdr へ KKP シーケンスが転送され、実運用で使えている

## Alternatives Considered

- tmux, WezTerm ネイティブ多重化: マルチプレクサ運用の詳細方針が未確定だったため、比較検討自体を行わなかった

## More Information

- ユーザー体験が悪化したと判断した時点で見直す(具体的な定量基準は未定義)
- 後続の決定: [0002-switch-to-native.md](./0002-switch-to-native.md)
