# terminal-env ADR

WezTerm のターミナルマルチプレクサ運用モード(herdr / native / tmux)に関する決定記録。

対象コード: [`home/modules/terminal/configs/wezterm/keybinds/`](/home/modules/terminal/configs/wezterm/keybinds/)

## 一覧

| # | タイトル | Status | Date |
|---|---|---|---|
| [0001](./0001-adopt-herdr.md) | herdr を WezTerm のマルチプレクサとして採用する | superseded by [0002](./0002-switch-to-native.md) | 2026-08-29 |
| [0002](./0002-switch-to-native.md) | WezTerm ネイティブ多重化へ切り替える | superseded by [0003](./0003-switch-to-tmux.md) | 2026-08-29 |
| [0003](./0003-switch-to-tmux.md) | tmux へ切り替える | superseded by [0004](./0004-switch-to-herdr.md) | 2026-08-29 |
| [0004](./0004-switch-to-herdr.md) | herdr へ再切り替える | accepted | 2026-09-05 |

## 命名規則

- ファイル名: `NNNN-slug.md` の連番形式(4桁ゼロ埋め)
- Status: `proposed` / `accepted` / `rejected` / `deprecated` / `superseded by [title](path)`
