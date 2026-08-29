 WezTerm キーバインド構成

## ファイル構成

| ファイル | 役割 |
|---|---|
| `default.lua` | エントリポイント。共通キー (common_keys) の定義と、モードの選択 |
| `used_herdr.lua` | herdr 使用時のキーバインド |
| `used_tmux.lua` | tmux 使用時のキーバインド |
| `wezterm_native.lua` | WezTerm ネイティブ多重化使用時のキーバインド |

### モード切り替え

`default.lua` 内の `multiplexer` の require を差し替える (いずれか1行を有効にする):

```lua
local multiplexer = require("keybinds.used_herdr")       -- herdr 使用時
-- local multiplexer = require("keybinds.used_tmux")      -- tmux 使用時
-- local multiplexer = require("keybinds.wezterm_native") -- WezTerm ネイティブ多重化に戻す場合
```

## 用語

**アクティブスペース** : セッション(workspace)・タブ・ペインを束ねる作業領域。
ターミナル内では常にこの領域を1つだけ展開し、複数存在させない。

- herdr → herdr が担当
- tmux → WezTerm workspace が担当
- native → WezTerm の1プロセスが担当

各モードの運用モデル図・転送シーケンス・モード固有の詳細は、対応する `.lua` ファイル先頭のコメントを参照。

## Prefix / Leader

**Shift+Space** で固定(3モード共通)。

- herdr : WezTerm が KKP シーケンスに変換して herdr へ転送 (herdr の prefix として機能)
- tmux  : WezTerm が KKP シーケンスに変換して tmux へ転送 (tmux 側で `prefix = S-Space` として解釈。tmux 3.2+ の `extended-keys` が必要)
- native : WezTerm の Leader キーとして直接使用 (転送なし、WezTerm 自身が処理)

herdr / tmux では **Prefix**、native では **Leader** という呼び方をするが実質同じキー。

**tmux のみの注意点** : Prefix 配下のキーは全て tmux への転送専用として扱う。WezTerm 自体の操作 (新規タブ・タブを閉じるなど) は Prefix ではなく **Cmd** を使う。

## アクティブスペース内の操作

3モード共通で以下の操作が用意されている。実際のキーバインドとモード固有の操作は各 `.lua` ファイル先頭のコメントを参照。

- 新規タブ(作業単位)
- タブを閉じる
- タブ切り替え
- 新規 workspace
- workspace 切り替え
- ペイン分割
- ペイン移動
- ペインを閉じる
- リサイズモード
- コピーモード

## 専用ツール起動

| 操作 | キー | herdr | tmux | native |
|---|---|---|---|---|
| btop | `Prefix+B` | popup 表示 | popup 表示 (`display-popup`) | 新規タブで起動 (タブ名 "tool" 固定) |
| localhost-top | `Prefix+P` | popup 表示 | popup 表示 (`display-popup`) | 新規タブで起動 (タブ名 "tool" 固定) |

## 共通キー (common_keys、全モードで常に有効)

| 操作 | キー | 備考 |
|---|---|---|
| 新規 WezTerm タブ | `Cmd+T` | WezTerm のネイティブタブを開く |
| フォントサイズトグル | `Ctrl+;` | Zen モード用。Neovim から呼び出し |
