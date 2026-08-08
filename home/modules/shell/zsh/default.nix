{ config, pkgs, ... }:

{
  imports = [
    ./env.nix
    ./aliases.nix
    ./functions
  ];

  # zsh基本設定
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # compaudit(全fpathの権限チェック)をスキップして起動を高速化
    completionInit = "autoload -U compinit && compinit -C";

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
