# dotfiles 検証手順（UTM macOS VM）

初回セットアップ手順が正しく動作するかを、本番環境に影響を与えずに検証するためのガイドです。

---

## なぜ VM で検証するのか

- 本番環境（現在使用中の Mac）を壊さずに、**ゼロからのセットアップを何度でも再現**できる
- 初回構築手順（README.md）をそのまま実行できる完全なクリーン環境
- 問題が発生してもスナップショットに戻せる

---

## 必要なもの

- **UTM**（無料の仮想化アプリ）
- Apple Silicon Mac（Virtualization.framework による高速動作）
- 空き容量: 64GB 以上推奨
- メモリ: 8GB 以上推奨（VM に 4〜8GB 割り当て）

---

## 手順

### 1. macOS VM の作成

1. UTM を起動
2. **「+」→「仮想化」** を選択
3. **「macOS 12+」** を選択
4. 「IPSW をダウンロード」ボタンで現在と同じ macOS バージョンを自動取得
5. ストレージ: **64GB 以上** に設定
6. メモリ: **8GB** 以上に設定
7. VM を保存し、起動して macOS をインストール

> **Note**: 「エミュレーション」ではなく「仮想化」を選ぶとネイティブ速度に近いパフォーマンスが得られます。

### 3. VM 内でのセットアップ検証

macOS のインストール完了後、VM 内のターミナルで README.md の手順を実行します。

#### 3-1. フルディスクアクセスの設定

```zsh
open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
```

ターミナルにフルディスクアクセスを付与し、ターミナルを再起動。

#### 3-2. Nix のインストール

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

新しいターミナルセッションを開く（または再起動）。

#### 3-2-1. Nix 実験的機能の有効化

Nix のインストール直後は `nix-command` と `flakes` が無効になっています。有効化しないと以降の手順が動作しません。

```zsh
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

#### 3-3. リポジトリのクローン

```zsh
git clone https://github.com/Hol1kgmg/dotfiles.git
cd dotfiles
```

#### 3-4. secrets.nix の作成

```zsh
cp local/secrets.nix.example local/secrets.nix
chmod 600 local/secrets.nix
vim local/secrets.nix  # gitUsername と gitEmail を編集
```

#### 3-5. home-manager の適用

```zsh
make init-home
```

#### 3-6. nix-darwin の適用

```zsh
make init-darwin
```

Homebrew 本体は nix-homebrew により自動インストールされます。

#### 3-7. home-manager の再適用

```zsh
make home
```

---

## 確認ポイント

| ステップ | 確認内容 |
|---|---|
| `make init-home` | エラーなく完了するか |
| `make init-darwin` | Homebrew が自動インストールされるか |
| `make home` | Homebrew 経由のアプリ設定が反映されるか |
| シェル起動 | `zsh` の設定（エイリアス・プロンプト）が正しく読み込まれるか |
| Neovim 起動 | `nvim` が起動し、プラグインが読み込まれるか |

---

## スナップショットの活用

UTM はスナップショット機能を持っています。

- **macOS インストール直後**にスナップショットを作成しておくと、何度でもクリーン状態に戻せます
- VM ウィンドウ → メニュー → 「スナップショット」から操作できます

---

## 関連ドキュメント

- [README.md](./README.md) — セットアップ手順（本手順の元となる手順書）
- [SETUP_TROUBLESHOOTING.md](./SETUP_TROUBLESHOOTING.md) — セットアップ時のトラブルシューティング
- [MANUAL_SETUP.md](./MANUAL_SETUP.md) — 手動対応が必要な項目
