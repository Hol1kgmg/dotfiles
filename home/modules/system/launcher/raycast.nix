# launcherアプリ Raycastのscript commands
#
# Raycast本体はHomebrew caskで管理し、scriptsの配置のみNixで行う。
# scriptsディレクトリのRaycastへの登録は手動
# (Raycast Settings -> Extensions -> Script Commands -> Add Directories)。

{ ... }:

{
  xdg.configFile."raycast/scripts".source = ./configs/raycast/scripts;
}
