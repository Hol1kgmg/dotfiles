---
status: 'accepted'
date: '2026-10-01'
decision-makers: 'Hol1kgmg'
---

# macSKKを撤退する

## Context and Problem Statement

[0001](./0001-adopt-macskk.md)でmacSKK + yaskkserv2を試験導入し、[0002](./0002-reject-mozkey.md)でも継続利用としたが、SKK方式による入力負荷への不満は解消されなかった。

実運用で明らかになったのは、自分にとって変換精度よりも入力速度の方が重要だということである。SKK方式は送り仮名や変換の開始位置を入力者が都度宣言するため、変換精度は高いが、考えながら打つ場面では手が止まる。特にカンファレンスなどで話されている内容をその場でメモするような、聞きながら追いつく速度が求められる入力では、この宣言のオーバーヘッドが致命的だった。試験導入の評価として、macSKKの利用をやめる。

## Decision Drivers

- 変換精度よりも入力速度を優先したい
- 話を聞きながらメモを取るような、思考速度に追従する入力でSKK方式は手が止まる
- 再有効化の可能性を残しつつ、日常の環境構築からは外したい

## Considered Options

- 設定を残したまま無効化する(import・caskのコメントアウト)
- 関連ファイルをすべて削除する

## Decision Outcome

設定を残したまま無効化する。

理由: 撤退は確定だが、`macskk.nix`のサンドボックス回避や`defaults write`の型指定などの知見はファイルに残しておく方が再利用しやすい。削除はgit履歴から復元できるとはいえ、import 2行とcask 1行を戻すだけで再有効化できる方が安い。

### Consequences

- Good, because `darwin-rebuild`時のHomebrew cleanup(`cleanup = "uninstall"`)でmacSKK.appが自動アンインストールされる
- Good, because yaskkserv2のlaunchd agentと辞書生成が止まる
- Neutral, because `nur-packages` inputはherdr/openscreenが使うため残る
- Bad, because 未使用の`macskk.nix`, `yaskkserv2.nix`, `kana-rule.conf`がリポジトリに残る

## Implementation Plan

- **Affected paths**: `home/modules/system/input/default.nix`, `nix-darwin/homebrew/cask/default.nix`, `mise.toml`
- **Dependencies**: `flake.nix`の`nur-packages`は変更なし
- **Patterns to follow**: 無効化はimportのコメントアウトで行い、ファイルは残す
- **Configuration**: `macskk-restart` miseタスクを削除
- **Migration steps**: `mise run home`と`darwin-rebuild switch`を実行。`~/Library/Containers/net.mtgto.inputmethod.macSKK`とUserDefaults(`net.mtgto.inputmethod.macSKK`)は自動では消えないため、不要なら手動で削除する

### Verification

- [ ] `launchctl list | grep yaskkserv2`が空になる
- [ ] `/Library/Input Methods/macSKK.app`が存在しない
- [ ] 日本語入力がmacOS標準IMEに戻っている

## More Information

- 関連ADR: [0001-adopt-macskk.md](./0001-adopt-macskk.md), [0002-reject-mozkey.md](./0002-reject-mozkey.md)
