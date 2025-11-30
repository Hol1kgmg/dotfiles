{
  # general
  username = builtins.getEnv "USER";

  # git（環境変数から取得。未設定の場合は手動設定が保持される）
  gitUsername = builtins.getEnv "GIT_USERNAME";
  gitEmail = builtins.getEnv "GIT_EMAIL";
  gitSigningkey = builtins.getEnv "GIT_SIGNINGKEY";
}
