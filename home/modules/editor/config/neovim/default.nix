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
  ];

  # Lua設定ファイルを配置
  xdg.configFile."nvim".source = ./configs;
}
