{ config, pkgs, ... }:

{
  imports = [
    ./env.nix
    ./aliases.nix
    ./functions.nix
  ];

  # zsh基本設定
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # 自動補完提案
    autosuggestion = {
      enable = true;
    };

    # 履歴設定
    history = {
      size = 10000;
      save = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    # シンタックスハイライト（オプション）
    # syntaxHighlighting = {
    #   enable = true;
    # };
  };
}
