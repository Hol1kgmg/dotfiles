# openscreen: 画面収録＋編集ツール（パッケージ定義はnur-packagesで管理）
#
# home-managerのlinkApps機能で ~/Applications/Home Manager Apps/ にエイリアスされる。
#
# データ保存先: ~/Library/Application Support/openscreen/
#   recordings/ 収録した動画(mp4)とセッション・カーソル軌跡のメタ情報
#   projects/   編集プロジェクトファイル(.openscreen)
#   stt-models/ 文字起こし用モデル(数百MB)
# nix store外の可変領域のため、switchやバージョン更新では消えない。
# Home Manager管理外なのでバックアップ・容量管理は手動。
{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.nur-packages.packages.${pkgs.stdenv.hostPlatform.system}.openscreen-for-mac
  ];
}
