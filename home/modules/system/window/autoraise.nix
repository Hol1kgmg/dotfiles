{ pkgs, ... }:
{
  # AutoRaise - マウスオーバーでウィンドウを自動的にフォーカス
  # help: ターミナルから起動するコマンド `AutoRaise`

  home.packages = [ pkgs.autoraise ];

  launchd.agents.autoraise = {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.autoraise}/bin/AutoRaise" ];
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
