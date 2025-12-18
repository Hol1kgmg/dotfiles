{ pkgs, ... }:

{
  # Neovim基本設定
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # $EDITOR環境変数を設定
    viAlias = true;        # vi コマンドでneovimを起動
    vimAlias = true;       # vim コマンドでneovimを起動
  };

  # Lua設定ファイルを配置
  xdg.configFile."nvim".source = ./configs;
}
