{ pkgs, ... }:

{
  # 開発用パッケージ
  home.packages = with pkgs; [
    nodejs_24  # Copilot.lua依存
  ];
}
