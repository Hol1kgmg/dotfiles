{ pkgs, ... }:

{
  # 開発用パッケージ
  home.packages = with pkgs; [
    pnpm
  ];
}
