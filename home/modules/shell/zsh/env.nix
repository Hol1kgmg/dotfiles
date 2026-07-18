{ config, pkgs, ... }:

{
  # 環境変数設定 (.zshenv)
  programs.zsh.envExtra = ''
    # Nix daemon (PATH, NIX_PROFILES等)
    # macOSのメジャーアップデートで /etc/zshrc がAppleのデフォルトにリセットされ、
    # Nixインストーラーが追加した読み込み設定が消えることがあるため、
    # ユーザー側のdotfilesで独立して読み込む
    if [ -z "$NIX_PROFILES" ] && [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
      . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    fi

    # Homebrew binaries
    if [ -d "/opt/homebrew/bin" ]; then
      export PATH="/opt/homebrew/bin:$PATH"
    fi

    # nix-darwin system binaries
    if [ -d "/run/current-system/sw/bin" ]; then
      export PATH="/run/current-system/sw/bin:$PATH"
    fi

    # user local binaries (e.g. cargo install, manual installs)
    if [ -d "$HOME/.local/bin" ]; then
      export PATH="$HOME/.local/bin:$PATH"
    fi

  '';
}
