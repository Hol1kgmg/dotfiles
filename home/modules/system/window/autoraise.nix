{ lib, ... }:
{
  # AutoRaise - マウスオーバーでウィンドウを自動的にフォーカス
  # インストールはHomebrewで管理 (nix-darwin/homebrew/cask)

  home.activation.autoRaiseSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Applying AutoRaise settings..."

    source ${./lib/app-control.sh}

    if ! check_app_installed "/Applications/AutoRaise.app"; then
      echo "AutoRaise is not installed yet. Skipping settings..."
      exit 0
    fi

    if ! stop_app_if_running "AutoRaise" "AutoRaise.app/Contents/MacOS/AutoRaise$"; then
      exit 0
    fi

    $DRY_RUN_CMD /usr/bin/defaults write com.sbmpost.AutoRaise autoRaiseEnabled -bool true
    $DRY_RUN_CMD /usr/bin/defaults write com.sbmpost.AutoRaise enableOnLaunch -bool true

    # 再起動はlaunchdが行うため不要
  '';

  launchd.agents.autoraise = {
    enable = true;
    config = {
      ProgramArguments = [ "/Applications/AutoRaise.app/Contents/MacOS/AutoRaise" ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
