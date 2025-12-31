{ config, pkgs, ... }:

{
  # エイリアス定義
  programs.zsh.shellAliases = {
    # Git関連
    g = "git";
    gm = "git merge";
    gm-dev = "git merge develop";
    gbdel = "git branch --merge|egrep -v '\\*|develop|main'|xargs git branch -d";
    greset = "git reset --soft HEAD^";
    groot = "git rev-parse --show-toplevel";

    # 開発ツール
    lg = "lazygit";
    ld = "lazydocker";
    dc = "docker compose";

    # zellij
    za = "zellij a";
    zl = "zellij ls";
    zda = "zellij delete-all-sessions";

    # nvim
    nvt = "nvim -c 'terminal' -c 'startinsert'";

    # nix
    nix-store-gc = "nix store gc";
  };
}
