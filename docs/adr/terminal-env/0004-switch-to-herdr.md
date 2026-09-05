---
status: 'accepted'
date: 2026-09-05
decision-makers: 'Hol1kgmg'
---

# herdr へ再切り替える

## Context and Problem Statement

[0003-switch-to-tmux.md](./0003-switch-to-tmux.md) で tmux をアクティブスペースの担当として採用したが、Prefix 配下のキーを「tmux への転送専用」として扱うモード固有の制約により、WezTerm自体の操作をCmdに退避する必要があり、native/herdr との操作体系の一貫性が完全ではないという課題が残っていた。

一方、[0001-adopt-herdr.md](./0001-adopt-herdr.md) 以来 herdr の再検討を妨げていた `HERDR_ENV` 残留による起動不能問題は、herdr 0.8.2 へのバージョンアップで修正された。複数の WezTerm セッション・ウィンドウを実際に開いて起動不能が再現しないことを確認し、[0002-switch-to-native.md](./0002-switch-to-native.md) で herdr を除外していた理由が解消したと判断した。

0001 時点での当初目的(AI エージェントをターミナル内で高性能に稼働させる)を再度優先し、herdr への切り替えを決定する。

## Decision

WezTerm のマルチプレクサ(アクティブスペース担当)を tmux から herdr へ再度切り替える。

- `default.lua` の `multiplexer` require を `used_tmux` から `used_herdr` に差し替える
- `terminal/default.nix` で `herdr.nix` を有効化する
- tmux/native との詳細な再比較検討は行わない(non-goal)。AI エージェント運用込みの定量評価も non-goal とする
- `tmux.nix` / `used_tmux.lua` は削除せず、フォールバック用にリポジトリへ残す

## Consequences

- Good, because HERDR_ENV 問題が解消したことで、0001 で企図していた「AI エージェントを高性能に稼働させる」構成を再び採用できる
- Good, because tmux で必要だった「Prefix配下はtmux転送専用、WezTerm操作はCmdに退避」というモード固有の制約から解放され、herdr のネイティブなキー体系に戻る
- Bad, because 0001 と同様、見直しトリガーは「ユーザー体験の悪化」という主観的な基準にとどまり、定量的な判断基準は定義していない
- Bad, because HERDR_ENV 問題の解消根拠は手元での動作確認のみであり、herdr 側の公式な修正内容(リリースノート等)までは追跡していない

## Implementation Plan

- **Affected paths**:
  - `home/modules/terminal/configs/wezterm/keybinds/default.lua`(multiplexer require を `used_tmux` → `used_herdr` に差し替え、既にステージ済み)
  - `home/modules/terminal/default.nix`(`herdr.nix` の import を有効化、既にステージ済み)
- **Dependencies**: herdr 0.8.2 以降(Nix経由、`herdr.nix` で管理)
- **Patterns to follow**: `default.lua` の `multiplexer` require 差し替え方式は [0001](./0001-adopt-herdr.md)〜[0003](./0003-switch-to-tmux.md) から変更しない
- **Patterns to avoid**: tmux/native 固有のキーバインドやワークアラウンドを `used_herdr.lua` に持ち込まない。`tmux.nix` / `used_tmux.lua` は削除しない(フォールバック用に維持)

### Verification

- [x] `default.lua` の multiplexer require が `used_herdr` になっている
- [x] `terminal/default.nix` で `herdr.nix` が有効化されている
- [x] 複数の WezTerm セッション・ウィンドウを開いても `HERDR_ENV` 残留による起動不能が再現しない
- [x] `tmux.nix` / `used_tmux.lua` がフォールバック用に削除されず残っている

## Alternatives Considered

- tmux 継続: Prefix配下の転送専用モードによる操作体系の一貫性低下が実運用で不便だったため、再比較なしで見送り
- WezTerm native 再検討: [0002](./0002-switch-to-native.md) で発生した複数ウィンドウ間の相互影響・Dock/Cmd+Tab 分裂問題は未解決のため対象外

## More Information

- 見直しトリガー: `HERDR_ENV` 残留問題の再発、またはユーザー体験の悪化(具体的な定量基準は未定義、0001と同様)
- 先行する決定: [0003-switch-to-tmux.md](./0003-switch-to-tmux.md)(このADRにより Superseded)
- 関連: [0001-adopt-herdr.md](./0001-adopt-herdr.md)、[0002-switch-to-native.md](./0002-switch-to-native.md)
