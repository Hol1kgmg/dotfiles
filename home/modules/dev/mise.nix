{ config, pkgs, ... }:

{
  # mise設定
  programs.mise = {
    enable = true;
    # home/modules/shell/zsh/functions/tool-init-cache.nix でキャッシュして source するため無効化
    enableZshIntegration = false;
    enableBashIntegration = true;

    # mise settings の管理
    globalConfig.settings = {
      experimental = true;
      idiomatic_version_file = true;
    };
  };

  xdg.configFile."mise/config.toml".force = true;
}
