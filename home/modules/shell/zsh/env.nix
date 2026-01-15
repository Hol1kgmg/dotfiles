{ config, pkgs, ... }:

{
  # 環境変数設定 (.zshenv)
  programs.zsh.envExtra = ''
    # nix-darwin system binaries
    if [ -d "/run/current-system/sw/bin" ]; then
      export PATH="/run/current-system/sw/bin:$PATH"
    fi

    # Homebrew binaries
    if [ -d "/opt/homebrew/bin/" ]; then
      export PATH="/opt/homebrew/bin/:$PATH"
    fi
  '';
}
