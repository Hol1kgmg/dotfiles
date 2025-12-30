# help: Zellij レイアウト選択関数
# コマンド: z
# 説明: fzfを使用してzellijのレイアウトを選択し、起動します
# 使い方: z

{ config, pkgs, ... }:

{
  # zsh関数定義
  programs.zsh.initContent = ''
    z() {
      local layout=$(ls ~/.config/zellij/layouts/*.kdl 2>/dev/null | xargs -n 1 basename -s .kdl | fzf --reverse --prompt="適用するレイアウトを選択 > ")
      if [[ -n "$layout" ]]; then
        zellij --layout "$layout"
      fi
    }
  '';
}
