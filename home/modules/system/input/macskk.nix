# SKK方式の日本語入力 macSKK 設定
# 参考: https://mtgto.github.io/macSKK/config/dictionary.html
#
# macSKK本体はHomebrew caskで管理し、辞書ファイルの配置と辞書設定(UserDefaults)のみNixで行う。
#
# macSKKはApp Sandbox化されているため、コンテナ内から/nix/storeへのsymlinkは
# "Operation not permitted"で開けない(サンドボックスの境界を越えられない)。
# そのため home.file (symlink) ではなく cp で実体コピーする。
#
# 辞書設定を反映してもmacSKKプロセスは自動では再起動しない(日本語入力中の中断を避けるため)。
# 反映させたい場合は `mise run macskk-restart` を実行すること。
#
# 注意: macSKK起動中に新規の辞書ファイルが初めて出現すると、
# macSKK自身のファイル監視がenabled=falseで設定を書き戻すことがある(競合)。
# 新しい辞書を追加した際に有効化されていない場合は、
# `mise run macskk-restart` → 再度 `mise run home` を実行すること。

{ pkgs, lib, ... }:

let
  # ファイル名に"utf8"を含まないためEUC-JPとしてmacSKKに認識される(元ファイルもEUC-JP)
  skkJisyoL = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
  containerDir = "Library/Containers/net.mtgto.inputmethod.macSKK/Data/Documents";
  documentsDir = "$HOME/${containerDir}";
in
{
  # macSKK側の辞書設定(有効化・エンコーディング)、およびskkserv(yaskkserv2)接続設定をUserDefaultsに反映
  home.activation.macskkDictionarySettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Applying macSKK settings..."

    if [ ! -d "/Library/Input Methods/macSKK.app" ]; then
      echo "macSKK is not installed yet. Skipping settings..."
      exit 0
    fi

    if [ ! -d "${documentsDir}" ]; then
      echo "macSKK container not found. Launch macSKK once, then run home-manager switch again."
      exit 0
    fi

    # サンドボックス越しのsymlinkは開けないため実体をコピーする
    $DRY_RUN_CMD mkdir -p "${documentsDir}/Dictionaries"
    $DRY_RUN_CMD rm -f "${documentsDir}/Dictionaries/SKK-JISYO.L"
    $DRY_RUN_CMD cp -f "${skkJisyoL}" "${documentsDir}/Dictionaries/SKK-JISYO.L"
    $DRY_RUN_CMD chmod 644 "${documentsDir}/Dictionaries/SKK-JISYO.L"

    $DRY_RUN_CMD mkdir -p "${documentsDir}/Settings"
    $DRY_RUN_CMD rm -f "${documentsDir}/Settings/kana-rule.conf"
    $DRY_RUN_CMD cp -f "${./kana-rule.conf}" "${documentsDir}/Settings/kana-rule.conf"
    $DRY_RUN_CMD chmod 644 "${documentsDir}/Settings/kana-rule.conf"

    $DRY_RUN_CMD /usr/bin/defaults write net.mtgto.inputmethod.macSKK dictionaries \
      '( { filename = "SKK-JISYO.L"; enabled = 1; encoding = 3; type = "traditional"; saveToUserDict = 1; } )' || true

    # yaskkserv2をskkservとして使用する設定
    # requestEncoding=3(EUC-JP), responseEncoding=4(UTF-8): yaskkserv2はUTF-8で応答を返せるため
    $DRY_RUN_CMD /usr/bin/defaults write net.mtgto.inputmethod.macSKK skkserv \
      '{ enabled = 1; address = "127.0.0.1"; port = 1178; requestEncoding = 3; responseEncoding = 4; saveToUserDict = 1; enableCompletion = 1; }' || true
  '';
}
