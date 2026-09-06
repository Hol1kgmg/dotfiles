---
status: 'rejected'
date: '2026-09-06'
decision-makers: 'Hol1kgmg'
---

# mozkeyへの移行を見送る

## Context and Problem Statement

[0001](./0001-adopt-macskk.md)でmacSKKを試験導入したが、SKK方式(送り仮名などの変換形式を事前宣言してから音を入力する方式)による入力負荷に不満があった(詳細は`SKK-note.md`参照)。代替として、Mozc(Google日本語入力)をベースにローカルファーストのライブ変換・Zenz補正を統合した個人製IME「mozkey」への切り替えを検討した。

mozkeyはHomebrew cask未対応で、GitHub Releasesの`.pkg`インストーラーからの手動導入のみがサポートされている。このdotfilesはNix/home-managerによる宣言的管理を前提としており(macSKKもHomebrew cask + home-managerの組み合わせで管理、[0001](./0001-adopt-macskk.md)参照)、mozkeyをこの管理パターンに乗せられるかどうかが導入可否の分かれ目だった。

## Decision Drivers

- 既存のNix宣言的管理パターン(Homebrew cask + home-manager、または`nur-packages`経由のNixパッケージ)を維持したい
- mozkeyの`.pkg`はコード署名済みのIME(Input Method Kit)アプリを含んでおり、署名・IME登録を壊さずに導入したい
- sudo権限を要する自動化ステップを増やしたくない
- 入力体験の改善という当初の目的に対して、導入コストが見合うかを判断したい

## Considered Options

- nur-package化(`.pkg`を展開しNixストアに再パッケージ)
- home.activationでのpkg自動インストール(curl + `installer`コマンド)
- 手動インストール+ドキュメント化のみ(Nixでの自動化を放棄)

## Decision Outcome

いずれの選択肢も採用せず、mozkeyへの移行を見送る。macSKK + yaskkserv2([0001](./0001-adopt-macskk.md)の構成)を継続利用する。

理由: 検討した3つの選択肢はいずれも、既存のNix宣言的管理の質(署名の健全性、sudo不要、Homebrew cask同等の再現性)を落とすトレードオフを伴っていた。入力体験の改善という目的に対して、導入コスト・保守コストが見合わないと判断した。

### Consequences

- Good, because macSKKの構成(`home/modules/system/input/macskk.nix`, `yaskkserv2.nix`)に変更が発生せず、既存の宣言的管理を維持できる
- Good, because 署名済みIMEアプリをNixストアに展開する際の署名破壊リスクを回避できた
- Neutral, because macSKKのSKK方式による入力負荷という根本課題は未解決のまま残る(`SKK-note.md`の評価は継続中)
- Bad, because Homebrew cask未対応のGUI IMEアプリは、今後も同様の理由で候補から外れる可能性が高い(選定時にcask対応の有無を先に確認する運用上の教訓として残す)

## Implementation Plan

このADRはrejected決定であり、コード変更は発生しない。

- **Affected paths**: `docs/adr/input-env/`(このADRファイルと`README.md`の一覧のみ)
- **Dependencies**: 変更なし。`home/modules/system/input/macskk.nix`, `home/modules/system/input/yaskkserv2.nix`は現状維持
- **Patterns to follow**: 該当なし(コード変更なし)
- **Patterns to avoid**: Homebrew cask未対応のGUI IME(Input Method Kit)アプリを、`.pkg`の展開・再パッケージによってNixストアで管理しようとしないこと(署名検証・IME登録が壊れるリスクがあるため)
- **Configuration**: 変更なし
- **Migration steps**: 該当なし(移行を行わないため)

### Verification

- [x] `docs/adr/input-env/0002-reject-mozkey.md`のstatusが`rejected`である
- [x] `docs/adr/input-env/README.md`の一覧に0002が追加されている
- [x] `home/modules/system/input/macskk.nix`, `yaskkserv2.nix`に変更がない(macSKK構成の継続を確認)

## Pros and Cons of the Options

### nur-package化

mozkeyの`.pkg`を展開し、Nixパッケージとして`nur-packages`(yaskkserv2と同様のパターン)で管理する案。

- Good, because yaskkserv2と同じ管理パターンに統一でき、Nixストアからの参照だけで完結する
- Bad, because コード署名済みの`.app`を含む`.pkg`を展開・再パッケージすると、署名検証やmacOSのInput Method Kit登録が壊れるリスクが高い
- Bad, because mozkeyのリリース構造が変わるたびにnur-packages側のメンテナンスが必要になる

### home.activationでのpkg自動インストール

GitHub Releasesから`.pkg`を`curl`で取得し、`installer -pkg ... -target /`をhome.activationスクリプトから実行する案。macSKKの実体コピー方式([0001](./0001-adopt-macskk.md)参照)と同様に、サンドボックス越しの制約を回避する発想。

- Good, because 署名済みバイナリをそのまま使えるため、署名検証は壊れない
- Bad, because `installer`コマンドの実行にsudo権限が必要になる場面があり、`home-manager switch`のフローと不整合が生じる
- Bad, because Homebrew caskが担っている「バージョン管理・アンインストール・キャッシュ」などの機能を自前で実装する必要がある

### 手動インストール+ドキュメント化のみ

Nixでの自動化を諦め、README/ADRに手動導入手順を記載するだけにする案。

- Good, because 実装コストが最小
- Neutral, because macSKKで実現していた宣言的管理(辞書配置・UserDefaults設定の自動反映)がmozkeyでは得られない
- Bad, because 環境再構築時に手動手順を都度実施する必要があり、このdotfilesの目的(宣言的な環境再現)に反する

## More Information

- 関連ADR: [0001-adopt-macskk.md](./0001-adopt-macskk.md)(macSKK採用の経緯、SKK方式のトレードオフ)
- 関連メモ: `SKK-note.md`(macSKKの入力体験上の課題を記録した個人メモ。このADRの検討動機となった)
- 検討対象リポジトリ: [koyasi777/mozkey](https://github.com/koyasi777/mozkey)
- 教訓: 今後IME/日本語入力関連ツールを検討する際は、Homebrew cask対応の有無を候補選定の最初のフィルタとする。cask未対応でNix管理パターンに乗らない場合、導入コストが見合わない可能性が高い
