# yaskkserv2: Google変換候補・キャッシュ対応のSKK辞書サーバー
# macSKK本体はskkservクライアントとして接続する(接続設定はmacskk.nixで行う)
#
# 参考: https://github.com/airRnot1106/dotfiles/blob/main/modules/home-manager/tool/macskk/default.nix

{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  yaskkserv2 = inputs.nur-packages.packages.${pkgs.stdenv.hostPlatform.system}.yaskkserv2;
  dictionaryPath = "${config.xdg.configHome}/skk/yaskkserv2.dictionary";
in
{
  home.packages = [ yaskkserv2 ];

  # SKK-JISYO.Lからyaskkserv2用の辞書ファイルを生成
  home.activation.yaskkserv2Dictionary = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Creating yaskkserv2 dictionary..."
    $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}/skk"
    $DRY_RUN_CMD ${yaskkserv2}/bin/yaskkserv2_make_dictionary \
      --dictionary-filename=${dictionaryPath} \
      ${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L
  '';

  launchd.agents.yaskkserv2 = {
    enable = true;
    config = {
      ProgramArguments = [
        "${yaskkserv2}/bin/yaskkserv2"
        "--no-daemonize"
        "--google-suggest"
        "--google-japanese-input=notfound"
        "--google-cache-filename=/tmp/yaskkserv2.cache"
        dictionaryPath
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/yaskkserv2.log";
      StandardErrorPath = "/tmp/yaskkserv2.err";
    };
  };
}
