{ config, pkgs, ... }:

{
  # カスタム初期化スクリプト (.zshrc)
  programs.zsh.initContent = ''
    # カスタム関数やスクリプトをここに追加

    # 例: 便利な関数
    # mkcd() {
    #   mkdir -p "$1" && cd "$1"
    # }
  '';
}
