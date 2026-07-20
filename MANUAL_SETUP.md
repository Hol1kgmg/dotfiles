# 手動セットアップが必要な項目

nix-darwin/home-manager では自動化できない項目の手動設定手順をまとめています。

---

## 1. macOS システム設定

nix-darwin で自動化できない設定項目：

### gh コマンドでアカウントログイン

```.zsh
gh auth login
```

```.zsh
? Where do you use GitHub? - GitHub.com
? What is your preferred protocol for Git operations on this host? - HTTPS
? Authenticate Git with your GitHub credentials? - Yes
? How would you like to authenticate GitHub CLI? - Login with a web browser
```

### Hammerspoon（Chrome縦型タブサイドバーのトグル）

[Chrome-Vertical-Tab-Sidebar-Toggle](https://github.com/Ha1baraA11/Chrome-Vertical-Tab-Sidebar-Toggle) を利用し、
Chrome の縦型タブサイドバーを `Cmd+S` またはマウス左端ホバーでトグルする。
`home.file` で `~/.hammerspoon/init.lua` は自動配置されるが、以下は手動設定が必要。

1. システム設定 → プライバシーとセキュリティ → アクセシビリティ で **Hammerspoon** に権限を付与
2. Chrome のアドレスバーで `chrome://flags/#vertical-tabs` を開き、**Vertical tabs** を有効化してChromeを再起動

動作モードは `home/modules/system/window/configs/hammerspoon/init.lua` 内の `SCHEME` 変数で切り替え可能（デフォルト: `3`）。

| 値 | モード |
|---|---|
| 1 | キーボードのみ（`Cmd+S`） |
| 2 | マウス左端ホバーのみ |
| 3 | キーボード + マウス（デフォルト） |

デバッグ用ホットキー：

| キー | 操作 |
|---|---|
| `Cmd+Alt+D` | サービス状態を表示 |
| `Cmd+Alt+B` | ChromeのAXボタン一覧をConsoleに出力 |
| `Cmd+Alt+R` | サービスを強制再起動 |

---

## チェックリスト

初回セットアップ完了後、以下を確認：

- [ ] gh コマンドでログインしました
- [ ] Hammerspoonにアクセシビリティ権限を付与しました
- [ ] Chromeで `chrome://flags/#vertical-tabs` を有効化しました

---

## トラブルシューティング

問題が発生した場合は、[SETUP_TROUBLESHOOTING.md](./SETUP_TROUBLESHOOTING.md)を参照してください。

---

## 参考
