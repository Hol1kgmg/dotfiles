# launcherアプリ vicinae設定
# help: キーバインド
# Toggle Vicinae   : cmd + space
#
# vicinae本体はHomebrew caskで管理し、設定ファイル・scriptsの配置とリロードのみNixで行う。
#
# 起動中のVicinaeを全て終了し、vicinaeコマンドの--serverオプションで1回だけ起動し直す。
#
# 起動処理はapp-control.shの restart_app_if_was_running (open -a) には統一していない。
# open -a --args server は再現性がなく起動しないことがあったため、
# 確実に動作するバイナリ直接実行(nohup)を採用している。

{ config, pkgs, lib, ... }:

{
  xdg.configFile."vicinae/scripts".source = ./configs/vicinae/scripts;

  xdg.configFile."vicinae/settings.json".text = lib.replaceStrings
    [ "@HOME@" ]
    [ config.home.homeDirectory ]
    (builtins.readFile ./configs/vicinae/settings.json);

  home.activation.vicinaeReload = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Reloading Vicinae..."

    # ヘルパー関数を読み込み
    source ${../window/lib/app-control.sh}

    # インストール確認
    if ! check_app_installed "/Applications/Vicinae.app"; then
      echo "Vicinae is not installed yet. Skipping reload..."
      exit 0
    fi

    # 起動中のVicinaeを全て終了する
    stop_app_if_running "Vicinae" "vicinae" || true

    echo "Vicinaeを起動します (server)..."
    nohup /Applications/Vicinae.app/Contents/MacOS/vicinae-cli server > /dev/null 2>&1 &
    disown
  '';
}
