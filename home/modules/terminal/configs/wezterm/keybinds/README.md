 WezTerm キーバインド構成

## ファイル構成

| ファイル | 役割 |
|---|---|
| `default.lua` | エントリポイント。共通キー (common_keys) の定義と、モードの選択 |
| `used_herdr.lua` | herdr など tmux 系マルチプレクサ使用時のキーバインド |
| `wezterm_native.lua` | WezTerm ネイティブ多重化使用時のキーバインド |

### モード切り替え

`default.lua` 内の `multiplexer` の require を差し替える (どちらか1行を有効にする):

```lua
local multiplexer = require("keybinds.used_herdr")       -- herdr など tmux 系マルチプレクサ使用時
-- local multiplexer = require("keybinds.wezterm_native") -- WezTerm ネイティブ多重化に戻す場合
```

## 用語

**アクティブスペース** : セッション(workspace)・タブ・ペインを束ねる作業領域

- マルチプレクサあり → herdr が担当 (WezTerm workspace は使わない)
- マルチプレクサなし → WezTerm が担当 (workspace = プロジェクト単位)

## 運用モデル

### マルチプレクサあり (used_herdr)

- ※ WezTerm workspace は封印(操作キーバインドを空で設定)
- ※ WezTerm タブも基本 1 枚運用 (Cmd+T で追加は可能だが常用しない)

```
WezTerm window(1workspace-1tab 運用)
└─┬─── アクティブスペース (herdr が担当) ───────────
  └── マルチプレクサ セッション
      ├── マルチプレクサ タブ (= 作業単位)
      │   ├── ペイン
      │   └── ペイン
      └── マルチプレクサ タブ
          └── ペイン
```

### マルチプレクサなし (wezterm_native)

```
WezTerm window
└─┬─── アクティブスペース (WezTerm が担当) ───────────
  └── WezTerm workspace (= プロジェクト単位)
      └── WezTerm タブ (= 作業単位)
          ├── WezTerm ペイン
          └── WezTerm ペイン
```

## Prefix / Leader

**Shift+Space** で固定。

- マルチプレクサあり : WezTerm が KKP シーケンスに変換してマルチプレクサへ転送 (herdr の prefix として機能)
- マルチプレクサなし : WezTerm の Leader キーとして直接使用

以下の表では両者をまとめて **Prefix** と表記する。

## アクティブスペース内の操作 (両モードで同じキー体系に統一)

| 操作 | キー | 備考 |
|---|---|---|
| 新規タブ | `Prefix+T` | |
| タブを閉じる | `Prefix+W` | 確認なし |
| タブ切り替え | `Alt+H` / `Alt+L` | |
| 新規 workspace | `Prefix+Shift+T` | native は cdi でディレクトリ選択 |
| workspace 切り替え | `Ctrl+Tab` / `Ctrl+Shift+Tab` | |
| ペイン分割 | `Prefix+H/J/K/L` | 左分割は 33% 幅 |
| ペイン移動 | `Alt+Shift+H/J/K/L` | |
| ペインを閉じる | `Prefix+X` | 確認なし |
| リサイズモード | `Prefix+R` | 下記「リサイズモード」参照 |
| コピーモード | `Prefix+V` | 下記「コピーモード」参照 |

### モード固有の操作

| 操作 | キー | モード |
|---|---|---|
| workspace を閉じる | `Prefix+Shift+D` | herdr のみ |
| サイドバー | `Cmd+S` | herdr のみ (used_herdr が KKP 転送) |

## 専用ツール起動

| 操作 | キー | used_herdr | wezterm_native |
|---|---|---|---|
| btop | `Prefix+B` | popup 表示 | 新規タブで起動 (タブ名 "tool" 固定) |
| localhost-top | `Prefix+P` | popup 表示 | 新規タブで起動 (タブ名 "tool" 固定) |

## 共通キー (common_keys、両モードで常に有効)

| 操作 | キー | 備考 |
|---|---|---|
| 新規 WezTerm タブ | `Cmd+T` | タイトル "tab" 固定 |
| フォントサイズトグル | `Ctrl+;` | Zen モード用。Neovim から呼び出し |

## used_herdr.lua の詳細 (herdr への転送)

herdr に届ける必要のあるキーを KKP (Kitty Keyboard Protocol) シーケンスとして送信する:

| キー | シーケンス | herdr 側の機能 |
|---|---|---|
| `Shift+Space` | `\x1b[32;2u` | prefix |
| `Cmd+S` | `\x1b[115;9u` | サイドバートグル |
| `Ctrl+Tab` | `\x1b[9;5u` | 次の workspace |
| `Ctrl+Shift+Tab` | `\x1b[9;6u` | 前の workspace |

このほか `Tab` / `Shift+Tab` は「WezTerm タブが複数あれば切り替え、単独ならそのままキーを送信」という動作
(基本 1 枚運用のため、通常はそのまま送信される)。

WezTerm workspace の操作キーは意図的に割り当てない (`Ctrl+Tab` の転送により、WezTerm デフォルトの
タブ切り替えも上書きされる)。

## wezterm_native.lua の詳細 (キーテーブル)

### リサイズモード (`Leader+R`)

| キー | 動作 |
|---|---|
| `h/j/k/l` | 3 セルずつリサイズ |
| `Escape` | 終了 |

### コピーモード (`Leader+V`)

vim 風の操作体系:

| キー | 動作 |
|---|---|
| `h/j/k/l` | カーソル移動 |
| `H/J/K/L` | 10 ずつ移動 |
| `w` / `b` | 単語単位で前進 / 後退 |
| `0` / `$` | 行頭 / 行末 |
| `g` / `G` | スクロールバック先頭 / 末尾 |
| `v` / `V` / `Ctrl+V` | Cell / Line / Block 選択 |
| `y` | クリップボードへコピーして終了 |
| `a` / `q` / `Escape` | 終了 |
