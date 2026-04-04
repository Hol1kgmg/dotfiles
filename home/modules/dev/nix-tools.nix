{ pkgs, ... }:

{
  # Nix開発ツール
  home.packages = with pkgs; [
    nixd        # Nix LSPサーバー
    neovim      # テキストエディタ
    ripgrep     # 高速grep
    fd          # 高速find
    tree-sitter # パーサーライブラリ
  ];
}
