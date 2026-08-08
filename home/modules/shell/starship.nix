{ config, pkgs, ... }:

# NOTE: starship は導入を検討したが不採用。
# 理由: 1) oh-my-posh の wholespace-custom.json テーマ(レスポンシブ切替・
#          npm/yarn アイコン・worktree数など)に対してテーマの自由度が大きく劣る
#       2) Transient Prompt が zsh 向けに標準対応しておらず、
#          zsh/functions/starship-transient.nix のような手動フック実装が必要になる
{
  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    enableBashIntegration = true;
  };
}
