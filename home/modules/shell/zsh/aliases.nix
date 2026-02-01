{ config, pkgs, lib, ... }:

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
    n = "nvim";
    nvt = "nvim -c 'terminal' -c 'startinsert'";

    # nix
    nix-store-gc = "nix store gc";

    # copilot
    copilot = lib.concatStringsSep " " [
      "copilot"
      # Deny dangerous operations
      "--deny-tool 'bash(git push*)'"
      "--deny-tool 'bash(gh * delete*)'"
      "--deny-tool 'bash(rm *)'"
      # Allow safe tools and basic commands
      "--allow-tool view glob grep"
      "--allow-tool 'bash(ls*)' 'bash(cat*)' 'bash(find*)' 'bash(cd*)'"
      # Allow git read operations
      "--allow-tool 'bash(git status*)' 'bash(git log*)' 'bash(git show*)' 'bash(git diff*)' 'bash(git branch*)' 'bash(git remote -v)'"
      # Allow gh operations
      "--allow-tool 'bash(gh repo view*)' 'bash(gh repo list*)'"
      "--allow-tool 'bash(gh pr view*)' 'bash(gh pr list*)' 'bash(gh pr diff*)' 'bash(gh pr checks*)'"
      "--allow-tool 'bash(gh issue view*)' 'bash(gh issue list*)'"
      "--allow-tool 'bash(gh run view*)' 'bash(gh run list*)'"
      "--allow-tool 'bash(gh browse*)' 'bash(gh search*)' 'bash(gh status*)'"
    ];
  };
}
