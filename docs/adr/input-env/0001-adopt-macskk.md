---
status: 'accepted'
date: 2026-09-06
decision-makers: 'Hol1kgmg'
---

# macSKKを導入する

## Context and Problem Statement

macOS標準IMEの予測変換精度に不満があり、改善策を探していた。Google日本語入力はRosettaを必要とするため既に不採用としている(`nix-darwin/homebrew/cask/default.nix`のコメント参照)。

そんな中、SKK方式の日本語入力システムである[macSKK](https://mtgto.github.io/macSKK/)が、入力体験の向上に繋がりそうな選択肢として浮上した。macSKKは未経験のIMEであり、実際の入力体験が自分に合うかどうかは使ってみるまで分からない。そのため、まずは試験導入として採用し、実運用の中で評価する。

macSKKはskkservクライアントとして外部辞書サーバーに接続できる。Google変換候補やキャッシュに対応した辞書サーバーを併用することで、SKK方式のまま予測変換の精度を補強できると考え、辞書サーバーとして[yaskkserv2](https://github.com/tokoroten-lab/yaskkserv2)を最初からセットで採用する。

## Decision

日本語入力方式をmacOS標準IMEからmacSKK + yaskkserv2の試験導入へ切り替える。

- macSKK本体はHomebrew caskで管理する(`nix-darwin/homebrew/cask/default.nix`)。App Sandbox化されているためNixストアの配置物をそのまま参照できず、home-managerによる管理はNixパッケージとして完結しない
- 辞書ファイル(SKK-JISYO.L)とかな入力ルール(kana-rule.conf)、およびmacSKKのUserDefaults設定(辞書有効化・エンコーディング・skkserv接続設定)はhome-manager(`home/modules/system/input/macskk.nix`)で管理する
- yaskkserv2はNixパッケージとして`home/modules/system/input/yaskkserv2.nix`で管理し、launchd agentとして常駐させる。Google変換候補とキャッシュを有効化する
- macSKKとyaskkserv2間の接続はskkservプロトコル(127.0.0.1:1178)で行う
- IME切り替えのため、メニューバーの入力メニュー表示を無効から有効に変更する(`keyboard/default.nix`, `nix-darwin/system/keyboard.nix`)
- SKK方式継続の是非(入力体験が合うかどうかの評価・継続/撤退の判断)は、このADRでは判断しない。試験導入後の評価は別途ADR(0002)で扱う(non-goal)
- macSKK以外のSKK実装との詳細比較、送り仮名指定方式やキーバインドの最適化は行わない(non-goal)

## Consequences

- Good, because macOS標準IMEの予測変換精度への不満を、SKK方式という別アプローチで改善できる可能性が生まれる
- Good, because 辞書ファイルや設定をNixで宣言的に管理でき、環境再構築時にも再現できる
- Good, because yaskkserv2併用によりSKK方式のままGoogle変換候補・キャッシュの恩恵を受けられる
- Bad, because macSKKはApp Sandbox化されており、home.file(symlink)による管理ができず、実体コピーによる同期(activation script)が必要になり、Nix管理としては不完全(手動での`mise run macskk-restart`実行が必要な場面がある)
- Bad, because macSKK自身のファイル監視と設定の競合により、新規辞書追加時に設定が意図せず無効化されるケースがあり、運用上の注意点として残る
- Bad, because SKK方式は未経験であり、入力体験が自分に合わない場合は撤退することになる(このADR単体では継続を保証しない)

## Implementation Plan

- **Affected paths**:
  - `home/modules/system/input/default.nix`(macskk.nix・yaskkserv2.nixのimport)
  - `home/modules/system/input/macskk.nix`(辞書配置・UserDefaults設定)
  - `home/modules/system/input/yaskkserv2.nix`(辞書サーバーパッケージ・launchd agent)
  - `home/modules/system/input/kana-rule.conf`(かな入力ルール設定)
  - `home/modules/system/default.nix`(`./input`のimport追加)
  - `home/modules/system/keyboard/default.nix` / `nix-darwin/system/keyboard.nix`(メニューバー入力メニュー表示を`true`に変更)
  - `nix-darwin/homebrew/cask/default.nix`(`macskk` cask追加)
  - `flake.nix`(`nur-packages` inputの追加、yaskkserv2取得用)
  - `mise.toml`(`macskk-restart`タスクの追加)
- **Dependencies**: `nur-packages`(`github:Hol1kgmg/nur-packages`)経由のyaskkserv2パッケージ、Homebrew cask経由のmacskk
- **Patterns to follow**: App Sandbox化されたアプリの設定同期は、home.file(symlink)ではなくhome.activationでのcp実体コピーを用いる(`macskk.nix`のパターン)
- **Patterns to avoid**: macSKKのコンテナディレクトリへsymlinkで配置しない(サンドボックスの境界を越えられずOperation not permittedになる)

### Verification

- [x] `home-manager switch`実行後、macSKKの辞書設定(SKK-JISYO.L, kana-rule.conf)がコンテナディレクトリに反映される
- [x] yaskkserv2がlaunchd agentとして起動し、macSKKからskkserv(127.0.0.1:1178)経由で接続できる
- [x] メニューバーに入力メニューが表示され、IME切り替えができる
- [ ] 試験導入としての入力体験の評価(継続/撤退判断)は0002で実施する

## Alternatives Considered

- macOS標準IME継続: 予測変換精度への不満が解消されないため、現状維持は不採用
- Google日本語入力: Rosettaが必須のため、既存の方針(Rosetta非依存の構成を優先)により不採用(既存決定、`nix-darwin/homebrew/cask/default.nix`のコメント参照)
- macSKK単体(yaskkserv2なし): 検討していない。macSKK採用時点でGoogle変換候補・キャッシュ対応の辞書サーバー併用を前提としていたため、最初からyaskkserv2とセットで採用した

## More Information

- 試験導入の評価・継続/撤退の判断は0002で扱う(このADRの見直しトリガーは0002側で定義する)
- 関連メモ: `SKK-note.md`(試験導入中に感じた入力体験上の課題を記録した個人メモ。0002作成時の材料とする)
