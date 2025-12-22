{ pkgs, ... }:

{
  # Neovim基本設定
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # $EDITOR環境変数を設定
    viAlias = true;        # vi コマンドでneovimを起動
    vimAlias = true;       # vim コマンドでneovimを起動
  };

  # Neovim依存ツール
  home.packages = with pkgs; [
    # 検索・Git関連
    ripgrep     # fff.nvim内部で使用（高速grep）
    fd          # fff.nvim内部で使用（高速find）
    lazygit     # snacks.lazygit用

    tree-sitter # tree-sitter-cli

    # LSPサーバー（9言語）
    nodePackages.typescript-language-server  # TypeScript/TSX
    pyright                                  # Python
    nil                                      # Nix
    nodePackages.yaml-language-server        # YAML
    taplo                                    # TOML
    nodePackages.vscode-langservers-extracted # JSON/HTML/CSS/ESLint
    nodePackages.vim-language-server         # Vim
    lua-language-server                      # Lua
    marksman                                 # Markdown
  ];

  # Lua設定ファイルを配置
  xdg.configFile."nvim".source = ./configs;
}
