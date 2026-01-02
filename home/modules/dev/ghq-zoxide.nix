# help: ghq + zoxide 統合設定
#
# 【概要】
# ghq（Gitリポジトリ管理）とzoxide（スマートcd）を統合し、
# リポジトリへの高速移動を実現
#
# 【利用可能なコマンド】
#
# cd [クエリ]
#   - zoxideのスマートジャンプ機能を使用
#   - 訪問頻度の高いディレクトリに優先的にマッチ
#   - 例: cd dotfiles
#
# cdi [クエリ]
#   - インタラクティブなディレクトリ選択
#   - ghqリポジトリをzoxideに自動同期してから選択画面を表示
#   - 例: cdi
#
# ghq get <URL>
#   - リポジトリを~/dev配下にクローン（自動整理）
#   - 例: ghq get https://github.com/user/repo
#
# ghq list [-p]
#   - 管理中のリポジトリ一覧を表示
#   - -p: フルパスで表示
#
# 【仕組み】
# - ghqルート: ~/dev
# - cdi実行時にghqリポジトリがzoxideに自動登録される
# - cdコマンドは__zoxide_z関数に置き換えられる

{ pkgs, ... }:
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--no-cmd"
    ];
  };
  home.packages = with pkgs; [
    ghq
  ];
  programs.git.settings.ghq.root = "~/dev";
  programs.zsh.initContent = ''
    __zoxide_list_missing() {
      diff \
        <( zoxide query --list | sort ) \
        <( ghq list -p | sort) \
        | grep '^> ' | sed 's/^> //'
    }

    __zoxide_add_missing() {
      local missing
      missing=( $( __zoxide_list_missing ) )
      if [[ ''${#missing[@]} -gt 0 ]]; then
        zoxide add $missing
      fi
    }

    cd(){
      if (( $+functions[__zoxide_z] )); then
        __zoxide_z "$@"
      else
        builtin cd "$@"
      fi
    }

    cdi() {
      __zoxide_add_missing
      __zoxide_zi "$@" || true
    }
  '';
}
