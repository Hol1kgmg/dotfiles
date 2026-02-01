{ ... }:
{
  # AutoRaise - マウスオーバーでウィンドウを自動的にフォーカス
  # インストールはHomebrewで管理 (nix-darwin/homebrew/cask)

  launchd.agents.autoraise = {
    enable = true;
    config = {
      ProgramArguments = [ "/opt/homebrew/bin/AutoRaise" ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
