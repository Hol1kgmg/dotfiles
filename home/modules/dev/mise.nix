{ config, pkgs, ... }:

{
  # mise設定
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # mise settings の管理
    globalConfig.settings = {
      experimental = true;
      idiomatic_version_file = true;
    };
  };
}
