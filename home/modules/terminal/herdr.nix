# herdr: ターミナルマルチプレクサ（パッケージ定義はnur-packagesで管理）
{ inputs, pkgs, ... }:

{
  home.packages = [ inputs.nur-packages.packages.${pkgs.stdenv.hostPlatform.system}.herdr ];

  xdg.configFile."herdr/config.toml".source = ./configs/herdr/config.toml;
}
