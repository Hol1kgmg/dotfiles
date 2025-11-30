{ config, pkgs, ... }:

{
  # エイリアス定義
  programs.zsh.shellAliases = {
    # 基本コマンド
    # ll = "ls -la";
    # la = "ls -A";
    # l = "ls -CF";

    # Git関連
    # g = "git";
    # gs = "git status";
    # ga = "git add";
    # gc = "git commit";
    # gp = "git push";

    # その他
    # .. = "cd ..";
    # ... = "cd ../..";
  };
}
