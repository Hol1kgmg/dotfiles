{ config, lib, ... }:
let
  # Flakeでは相対パスが使えないため、絶対パスで参照
  secretsPath = "${config.home.homeDirectory}/dotfiles/home/secrets";
  secrets = if builtins.pathExists secretsPath
    then import secretsPath
    else { gitUsername = ""; gitEmail = ""; gitSigningkey = ""; };
in
{
  home.sessionVariables = lib.mkIf (secrets.gitUsername != "") ({
    GIT_USERNAME = secrets.gitUsername;
    GIT_EMAIL = secrets.gitEmail;
  } // lib.optionalAttrs (secrets.gitSigningkey != "") {
    GIT_SIGNINGKEY = secrets.gitSigningkey;
  });
}
