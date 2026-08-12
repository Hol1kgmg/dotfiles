{ ... }:

{
  programs.direnv = {
    enable = true;
    # home/modules/shell/zsh/functions/tool-init-cache.nix でキャッシュして source するため無効化
    enableZshIntegration = false;

    nix-direnv.enable = true;
  };
}
