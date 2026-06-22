{ lib, secrets, ... }:
{
  home.sessionVariables = lib.mkIf (secrets.gitUsername != "") (
    {
      GIT_USERNAME = secrets.gitUsername;
      GIT_EMAIL = secrets.gitEmail;
    }
    // lib.optionalAttrs (secrets.gitSigningkey != "") {
      GIT_SIGNINGKEY = secrets.gitSigningkey;
    }
  );

  programs.git.signing = lib.mkIf (secrets.gitSigningkey != "") {
    key = secrets.gitSigningkey;
    signByDefault = true;
  };

  programs.git.settings = lib.optionalAttrs (secrets.gitUsername != "" && secrets.gitEmail != "") {
    user = {
      name = secrets.gitUsername;
      email = secrets.gitEmail;
    };
  };
}
