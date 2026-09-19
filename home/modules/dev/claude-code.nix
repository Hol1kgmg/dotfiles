# Claude Code CLI
#
# 自動更新は無効（wrapperがDISABLE_AUTOUPDATER=1を設定）。
# 更新は `nix flake update nix-claude-code` を実行する。
#
# 参考: https://github.com/ryoppippi/nix-claude-code

{
  inputs,
  pkgs,
  ...
}:

{
  # claudeはghとpoppler-utilsを同梱（最小構成はclaude-minimal）
  home.packages = [ inputs.nix-claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude ];
}
