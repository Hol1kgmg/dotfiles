{ config, pkgs, ... }:

{
  # mise設定
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    # mise settings の管理
    settings = {
      experimental = true;
      tools = {
        python = {
          idiomatic_version_file = true;
        };
      };
    };
  };
}
