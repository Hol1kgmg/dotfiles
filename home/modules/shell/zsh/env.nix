{ config, pkgs, ... }:

{
  # macOS標準のpath_helper(/etc/zprofile)が/usr/local/binを
  # PATH先頭に割り込ませてくるため、その後に読まれる.zprofileで
  # /opt/homebrew/binを再度先頭に戻す
  # (path_helperがない場合はenvExtraの設定がそのまま活きる)
  programs.zsh.profileExtra = ''
    if [ -d "/opt/homebrew/bin" ]; then
      export PATH="/opt/homebrew/bin:$PATH"
    fi
  '';

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
