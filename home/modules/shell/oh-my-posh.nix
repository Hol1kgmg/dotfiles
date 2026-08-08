{ config, pkgs, ... }:

{
  # Oh My Posh設定
  programs.oh-my-posh = {
    enable = true;
    # zsh は home/modules/shell/zsh/functions/oh-my-posh-init-cache.nix で
    # `oh-my-posh init zsh` の出力をキャッシュして source するため、
    # 毎回動的生成する home-manager 標準の自動 eval は無効化
    enableZshIntegration = false;
    enableBashIntegration = true;
    configFile = ./configs/wholespace-custom.json;
  };
}
