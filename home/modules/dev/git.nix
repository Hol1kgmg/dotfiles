{ pkgs, lib, ... }:
let
  inherit (import ../../options.nix) gitUsername gitEmail gitSigningkey;
in
{
  programs.git = {
    enable = true;

    # GPG署名設定（GIT_SIGNINGKEYが設定されている場合のみ有効）
    signing = lib.mkIf (gitSigningkey != "") {
      key = gitSigningkey;
      signByDefault = true;
    };

    # 設定（新しいAPI）
    settings = {
      # 基本設定
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "current";
      core.editor = "vim";
    } // lib.optionalAttrs (gitUsername != "" && gitEmail != "") {
      # 環境変数が設定されている場合のみuser設定を追加
      user = {
        name = gitUsername;
        email = gitEmail;
      };
    };
  };
}
