# ランチャーアプリ設定

## 移行方針

Raycastからvicinaeへ移行中。vicinaeで代替できないraycast拡張機能は
他ツール + scripts機能の併用でカバーする。

## 移行状況
vicinaeへの移行を中断。
JP・ENの言語切り替えやclipboard historyの連携などの動作不良により、利用体験がよくなかったため。

## Raycast拡張機能の移行計画

| Raycast拡張機能 | 対応方針 | 備考 |
|---|---|---|
| `@huzef44/store.raycast.screenocr` | TRexで代替 | `system/window/trex.nix`で設定管理、vicinaeからscript経由で呼び出し |
| `@thomas/store.raycast.color-picker` | vicinae標準機能で代替可 | そのまま活用 |

## ファイル構成

| ファイル | 役割 |
|---|---|
| `vicinae.nix` | vicinae本体の設定(xdg.configFile配置、リロード処理) |
| `configs/vicinae/` | settings.json、scripts配置 |
