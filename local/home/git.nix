{ lib, pkgs, secrets, ... }:
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

  home.activation.setGitUser = lib.mkIf (secrets.gitUsername != "" && secrets.gitEmail != "") (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.git}/bin/git config --file "$HOME/.gitconfig" user.name "${secrets.gitUsername}"
      $DRY_RUN_CMD ${pkgs.git}/bin/git config --file "$HOME/.gitconfig" user.email "${secrets.gitEmail}"
    ''
  );
}
