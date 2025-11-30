# 開発者向けガイド

dotfilesの開発・改修時の環境セットアップについて説明します。

---

## MCP設定

このプロジェクトでは、Claude Codeで[mcp-nixos](https://github.com/utensils/mcp-nixos)を使用しています。

### 提供される機能

- 130K+ NixOSパッケージの検索
- 22K+ 設定オプションの参照
- Home Manager/nix-darwin設定の支援

### セットアップ

`.mcp.json`がプロジェクトルートに配置済みです。このディレクトリでClaude Codeを起動すると自動的に有効化されます。

**前提条件**: `uv`パッケージ（home-managerで管理済み）

**確認方法**:
```bash
# uvのインストール確認
uv --version

# Claude Code内でMCP確認
/mcp
```
