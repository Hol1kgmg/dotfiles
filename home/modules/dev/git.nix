{ pkgs, ... }:
let
  inherit (import ../../options.nix) gitUsername gitEmail gitSigningkey;
in
{
  programs.git = {
    enable = true;

    # GPG署名設定（GIT_SIGNINGKEYが設定されている場合のみ有効）
    signing = {
      key = gitSigningkey;
      signByDefault = gitSigningkey != "";
    };

    # 設定（新しいAPI）
    settings = {
      # ユーザー情報（環境変数から取得）
      user = {
        name = gitUsername;
        email = gitEmail;
      };

      # 基本設定
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "current";
      core.editor = "vim";

      # エイリアス
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
      };
    };
  };
}
