let
  homeDir = builtins.getEnv "HOME";
  secretsPath = "${homeDir}/dotfiles/home/secrets";
  secrets =
    if builtins.pathExists secretsPath then
      import secretsPath
    else
      {
        gitUsername = "";
        gitEmail = "";
        gitSigningkey = "";
      };
in
{
  # general
  username = builtins.getEnv "USER";

  # git（secrets.nixから取得）
  gitUsername = secrets.gitUsername;
  gitEmail = secrets.gitEmail;
  gitSigningkey = secrets.gitSigningkey;
}
