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

---

## チェックリスト

初回セットアップ完了後、以下を確認：

- [ ] gh コマンドでログインしました

---

## トラブルシューティング

Neovimで問題が発生した場合は、[NEOVIM_TROUBLESHOOTING.md](./NEOVIM_TROUBLESHOOTING.md)を参照してください。

---

## 参考
