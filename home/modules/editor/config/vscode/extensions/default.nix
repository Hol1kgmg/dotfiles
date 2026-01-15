{ pkgs, ... }:

{
  programs.vscode.profiles.default.extensions =
    # nixpkgs標準の拡張機能（安定版・推奨）
    (with pkgs.vscode-extensions; [
      # 日本語
      ms-ceintl.vscode-language-pack-ja

      # 言語サポート
      bbenoist.nix
      bierner.markdown-mermaid

      # UI。UX
      catppuccin.catppuccin-vsc-icons
      oderwat.indent-rainbow
      aaron-bond.better-comments
      gruntfuggly.todo-tree
      humao.rest-client

      # コード品質・フォーマッター
      dbaeumer.vscode-eslint
      usernamehw.errorlens
      streetsidesoftware.code-spell-checker
      esbenp.prettier-vscode

      # AIアシスタント
      github.copilot
      github.copilot-chat
    ])
    ++
    # vscode-marketplace拡張機能（nixpkgs標準にないもののみ）
    (with pkgs.vscode-marketplace; [
      # Kanagawa テーマ
      metaphore.kanagawa-vscode-color-theme

      # TypeScript型プレビュー
      mylesmurphy.prettify-ts
    ]);

  # TODO: プログラミング言語別の拡張機能を追加
  # 例: TypeScript, Python, Rust, Go などの言語固有の拡張機能
}

