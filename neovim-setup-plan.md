# Neovim環境構築プラン

## 目的
軽量でシンプル、かつ実用的なNeovim開発環境を構築する。
過度な装飾を避け、コーディング効率と起動速度を重視した構成とする。

## 基本方針

### ターゲット
- **ユーザーレベル**: Neovim使用経験あり
- **対象言語**: TypeScript/TSX, Python, Nix, YAML, TOML, JSON, Vim, Lua, Markdown
- **プラグイン数**: 12-16個程度（軽量構成）
- **管理方法**: Nix + lazy.nvim ハイブリッド

### コンセプト
- 🚀 **軽量・高速**: 起動速度を重視、遅延読み込み活用
- 🎯 **実用性**: LSP・補完・Git統合で実務対応
- 🧹 **ミニマル**: 必要最低限の機能に絞る
- 🔧 **保守性**: 定番プラグインで長期保守を考慮

## ディレクトリ構造

```
home/modules/editor/config/neovim/
├── default.nix              # Nix設定（programs.neovim + 依存ツール）
└── configs/                 # Lua設定ファイル群
    ├── init.lua             # エントリーポイント
    ├── lua/
    │   ├── config/
    │   │   ├── options.lua  # Neovim基本オプション設定
    │   │   └── keymaps.lua  # キーマッピング定義
    │   ├── lazy-setup.lua   # lazy.nvim設定とオプション
    │   └── plugins/         # プラグイン定義（機能別に分割）
    │       ├── colorscheme.lua  # カラースキーム
    │       ├── ui.lua           # UI・キーヘルプ
    │       ├── editor.lua       # エディタ機能
    │       └── navigation.lua   # ファイル操作・検索
    └── snippets/            # カスタムスニペット（言語別）
        ├── lua.lua
        ├── typescript.lua
        ├── python.lua
        ├── nix.lua
        └── markdown.lua
```

## 実装方針

### Nix管理範囲
- Neovim本体（`programs.neovim.enable = true`）
- LSPサーバー（6言語対応）
  - TypeScript: `typescript-language-server`
  - Python: `pyright`
  - Nix: `nil` または `nixd`
  - JSON: `vscode-langservers-extracted`
  - Lua: `lua-language-server`
  - Markdown: marksman
- 依存ツール
  - `ripgrep`: 高速grep
  - `fd`: 高速find
  - `nodejs`: 一部プラグイン依存
  - `tree-sitter-cli`: treesitter用

### lazy.nvim管理範囲
- 全プラグインとその設定
- プラグインの遅延読み込み設定
- カラースキーム

### メリット
- ✅ Nixで環境の再現性を保証
- ✅ lazy.nvimでプラグイン更新が容易
- ✅ 遅延読み込みで起動高速化
- ✅ 設定変更が即座に反映

## 機能要件

### カバーする機能（4カテゴリ）

#### 1. 必須基盤（3-4個）
- カラースキーム（Catppuccin推奨 - VSCodeと統一）
- ファジーファインダー（ファイル検索・grep）
- Treesitter（構文解析・シンタックスハイライト）

#### 2. LSP・補完（4-5個）
- LSP設定管理
- 補完エンジン（最小構成）
- LSP補完ソース
- バッファ補完
- 必要最低限のスニペット

#### 3. 編集補助（3-4個）
- オートペア（括弧・クォートの自動閉じ）
- コメント操作（トグル）
- 囲み操作（surround）
- キーバインドヘルプ（学習支援）

#### 4. ミニマルUI（2-3個）
- シンプルなステータスライン
- Git差分表示
- アイコン表示（視認性向上）

### 除外するもの
- ❌ ファイルツリー（Netrw使用）
- ❌ 複雑なタブライン
- ❌ 過度な装飾系プラグイン
- ❌ 通知システム
- ❌ デバッガー（必要に応じて後で追加）

## 基本キーマッピング方針

```
Leader key: <Space>

# ファイル操作
<leader>ff  - ファイル検索
<leader>fg  - 文字列検索（grep）
<leader>fb  - バッファ一覧
<leader>fh  - 最近開いたファイル

# LSP
gd          - 定義ジャンプ
gr          - 参照検索
K           - ホバー情報
<leader>ca  - コードアクション
<leader>rn  - リネーム

# 編集
gcc         - コメントトグル
<leader>w   - 保存
<leader>q   - 終了

# Git
<leader>gb  - Git blame
<leader>gp  - 前の変更
<leader>gn  - 次の変更
```

## 実装ステップ（段階的導入）

各ステップごとに動作確認を行い、問題なければ次へ進む方針。

**重要**: プラグインを導入する各ステップでは、**いきなり実装せず**、まず以下の流れで進める：
1. **専用ドキュメント作成** - `neovim-step-N-plan.md` を作成
2. **プラグイン選定** - 専用ドキュメントで候補を調査・選定
3. **プラン確認** - 選定したプラグインと設定方針をレビュー
4. **実装** - プラン承認後に実装開始
5. **動作確認** - 機能が正しく動作するか確認
6. **ドキュメント削除** - 完了後、専用ドキュメントを削除

### ドキュメント命名規則
- Step 1: `neovim-step1-foundation-plan.md`
- Step 2: `neovim-step2-colorscheme-plan.md`
- Step 3: `neovim-step3-oil-plan.md`
- Step 4: `neovim-step4-telescope-plan.md`
- Step 5以降: 同様にステップ番号とテーマで命名

### Step 1: 基盤構築（Neovim + 基本設定 + lazy.nvim）✅
1. ✅ ディレクトリ構造作成
2. ✅ `default.nix` 実装（Neovim有効化）
3. ✅ `init.lua` 作成（lazy.nvim bootstrap含む）
4. ✅ `lua/config/options.lua` 実装（基本オプション）
5. ✅ `lua/config/keymaps.lua` 実装（基本キーマップ）
6. ✅ `lua/plugins/init.lua` 作成（空のプラグインリスト + rocks無効化）
7. ✅ `home/modules/editor/default.nix` に統合
8. ✅ **rebuild & 動作確認**
   - `nvim --version` で動作確認
   - 基本設定（行番号、タブ幅等）の動作確認
   - `:Lazy` コマンドが使えるか確認
   - lazy.nvim healthcheck ✅

### Step 2: カラースキーム導入✅
9. ✅ カラースキームプラグイン選定・追加（kanagawa.nvim）
10. ✅ **Neovim起動 & 配色確認**
   - テーマが正しく適用されているか
   - kanagawa-wave適用済み

### Step 3: ファイラー（mini.files + mini.icons）導入✅
11. ✅ mini.files + mini.iconsプラグイン追加
12. ✅ キーマッピング設定（`<leader>e`/`<leader>E`でmini.files起動）
13. ✅ **mini.files動作確認**
   - ファイルブラウザが開く（カラム表示）
   - ファイル操作（移動、リネーム、削除）が動作
   - アイコン表示が正常に動作

### Step 4: ファジーファインダー（fff.nvim + snacks.nvim）導入✅
14. ✅ `default.nix` に依存ツール追加（ripgrep, fd, lazygit）
15. ✅ fff.nvim + snacks.nvimプラグイン追加
16. ✅ キーマッピング設定（fff.nvim, snacks.nvim）
17. ✅ **動作確認**
   - `<leader>ff` でファイル検索
   - `<leader>fb` でバッファ一覧
   - `<leader>fh` で最近開いたファイル
   - `<leader>gg` でLazyGit起動
   - `<leader>t` でターミナル起動
   - `:FFFHealth` で健全性チェック

### Step 5: Treesitter導入 + プラグイン設定モジュール化✅
18. ✅ `default.nix` にtree-sitter-cli追加
19. ✅ Treesitterプラグイン追加（10言語対応: TypeScript/TSX, Python, Nix, YAML, TOML, JSON, Vim, Lua, Markdown）
20. ✅ プラグイン設定を機能別に分割
   - `colorscheme.lua`: カラースキーム（kanagawa.nvim）
   - `ui.lua`: UI・キーヘルプ（mini.icons, mini.tabline, mini.clue, snacks.nvim）
   - `editor.lua`: エディタ機能（nvim-treesitter）
   - `navigation.lua`: ファイル操作・検索（mini.files, fff.nvim）
   - `lazy-setup.lua`: lazy.nvim設定とオプション
21. ✅ **シンタックスハイライト & 設定確認**
   - 各言語ファイルでハイライト動作確認
   - モジュール化された設定が正常に読み込まれることを確認

### Step 6: LSPサーバー導入✅
22. ✅ `default.nix` にLSPサーバー追加（対応言語）
23. ✅ LSPConfigプラグイン追加（基本設定のみ）
24. ✅ **rebuild & LSP動作確認**
   - 各言語ファイルで `:LspInfo` 確認
   - `gd`（定義ジャンプ）、`K`（ホバー）動作確認

### Step 7: 補完機能導入✅
25. ✅ blink.cmp + 各種ソース追加（snippets, lsp, path, buffer）
26. ✅ スニペットエンジン追加（LuaSnip + friendly-snippets）
27. ✅ カスタムスニペットディレクトリ作成・設定
   - `snippets/lua.lua`: Lua用スニペット
   - `snippets/typescript.lua`: TypeScript/JavaScript用スニペット
   - `snippets/python.lua`: Python用スニペット
   - `snippets/nix.lua`: Nix用スニペット
   - `snippets/markdown.lua`: Markdown用スニペット
28. ✅ **補完動作確認**
   - コード入力時に補完メニュー表示確認
   - スニペット展開確認（friendly-snippets + カスタムスニペット）

### Step 8: 編集補助プラグイン導入✅
29. ✅ オートペア追加（nvim-autopairs, nvim-ts-autotag）
30. ✅ コメント、surround追加（mini.comment, mini.surround）
31. ✅ **編集機能確認**
   - 括弧の自動閉じ ✅
   - HTMLタグの自動閉じ ✅
   - `gcc` でコメントトグル ✅
   - surround操作（`sa`, `sd`, `sr`） ✅

### Step 9: UI・Git統合✅
32. ✅ ステータスライン追加（lualine.nvim）
33. ✅ Git差分表示追加（gitsigns.nvim）
34. ✅ gitsignsキーマップを`lua/config/keymaps/git.lua`に移動
35. ✅ **UI・Git機能確認**
   - ステータスライン表示（mode, branch, diff, diagnostics, filename, progress, location）
   - Git差分の視覚化（add, change, delete, untracked）
   - ハンク間の移動（`]c`, `[c`）
   - Git操作（`<leader>hs/hr/hp/hb/hd`等）

### Step 10: 最終確認・完了
36. ⬜ 全機能の統合テスト
37. ⬜ 各言語での実作業テスト
38. ⬜ プランドキュメント削除
39. ⬜ `DEVELOPMENT_PLAN.md` 更新

## 検討事項

### 決定済み
- ✅ 配置場所: `home/modules/editor/config/neovim/`
- ✅ プラグイン管理: Nix + lazy.nvim ハイブリッド
- ✅ 初期構成: 最小構成（12-16個程度）
- ✅ 対象言語: TypeScript/TSX, Python, Nix, YAML, TOML, JSON, Vim, Lua, Markdown
- ✅ カラースキーム: kanagawa.nvim（kanagawa-wave）
- ✅ プラグイン設定: 機能別モジュール化（colorscheme, ui, editor, navigation）
- ✅ 補完エンジン: blink.cmp（super-tabキーマップ）
- ✅ スニペット: LuaSnip + friendly-snippets + カスタムスニペット（言語別ファイル管理）

### 未決定（実装時に決定）
- ⬜ Nix LSPサーバー: `nil` vs `nixd`
- ⬜ フォーマッター管理: Nixで追加するか、null-ls/conform.nvim使うか

## 参考資料
- **既存構成**:
  - VSCode設定: `home/modules/editor/config/vscode/`
  - WezTerm設定: `home/modules/terminal/configs/wezterm/`
- **公式ドキュメント**:
  - lazy.nvim: https://github.com/folke/lazy.nvim
  - nvim-lspconfig: https://github.com/neovim/nvim-lspconfig
