# macism: 入力ソース切替CLI (nixpkgs管理)
# 初回実行時にターミナルへのアクセシビリティ許可が必要
{ pkgs, ... }:

{
  home.packages = [ pkgs.macism ];
}
