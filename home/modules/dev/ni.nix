{ pkgs, ... }:

# help: niコマンド (@antfu/ni)
# パッケージマネージャーを自動検出して実行するユニバーサルコマンド
#
# | ni コマンド     | npm コマンド              |
# |-----------------|---------------------------|
# | ni              | npm install               |
# | ni <pkg>        | npm install <pkg>         |
# | ni -D <pkg>     | npm install -D <pkg>      |
# | nr <script>     | npm run <script>          |
# | nr dev          | npm run dev               |
# | nun <pkg>       | npm uninstall <pkg>       |
# | nlx <pkg>       | npx <pkg>                 |
# | nup             | npm update                |
# | nci             | npm ci                    |
# | nd              | npm dedupe                |
#
# インタラクティブモード:
# | nr              | スクリプト一覧を表示して選択 |

{
  # use the right package manager
  # Docs: https://github.com/antfu-collective/ni
  home.packages = with pkgs; [
    ni
  ];
}
