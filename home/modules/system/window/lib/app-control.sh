# macOSアプリの起動制御用ヘルパー関数
# 使用方法: source でこのファイルを読み込んで関数を呼び出す

# アプリがインストールされているか確認
# 引数: $1 = アプリパス (例: /Applications/Rectangle.app)
# 戻り値: 0 = インストール済み, 1 = 未インストール
check_app_installed() {
  local app_path="$1"
  if [ ! -d "$app_path" ]; then
    return 1
  fi
  return 0
}

# アプリのプロセス数を取得
# 引数: $1 = プロセスパターン (例: Rectangle.app/Contents/MacOS/Rectangle$)
# 出力: プロセス数
get_app_process_count() {
  local process_pattern="$1"
  local count
  count=$(/bin/ps aux | /usr/bin/grep -v grep | /usr/bin/grep -ci "$process_pattern" 2>/dev/null || echo "0")
  echo "$count" | /usr/bin/tr -d '\n'
}

# エラーメッセージを目立つ色（赤）で出力
# 引数: $1 = エラーメッセージ（複数行可）
print_error() {
  local message="$1"
  local red='\033[1;31m'
  local reset='\033[0m'
  local line

  while IFS= read -r line; do
    printf "${red}%s${reset}\n" "$line"
  done <<< "$message"
}

# アプリが起動中なら終了させる
# 引数: $1 = アプリ名 (例: Rectangle), $2 = プロセスパターン
# 環境変数: APP_WAS_RUNNING に起動状態を保存
# 戻り値: 0 = 成功, 1 = 終了失敗
stop_app_if_running() {
  local app_name="$1"
  local process_pattern="$2"
  local running

  running=$(get_app_process_count "$process_pattern")
  APP_WAS_RUNNING="$running"

  if [ "$running" -gt 0 ] 2>/dev/null; then
    echo "${app_name}起動中のため終了します..."
    local quit_error
    quit_error=$(/usr/bin/osascript -e "quit app \"$app_name\"" 2>&1 >/dev/null) || true

    # 終了を確認（最大10秒待機）
    local counter=0
    while [ $counter -lt 10 ]; do
      local still_running
      still_running=$(get_app_process_count "$process_pattern")

      if [ "$still_running" -eq 0 ] 2>/dev/null; then
        echo ""
        echo "${app_name}の終了を確認しました"
        return 0
      fi
      echo -n "."
      sleep 1
      counter=$((counter + 1))
    done
    echo ""

    # まだ起動している場合は強制終了を試みる
    local final_check
    final_check=$(get_app_process_count "$process_pattern")
    if [ "$final_check" -gt 0 ] 2>/dev/null; then
      echo "${app_name}が正常終了しなかったため強制終了します..."
      /usr/bin/pkill -fi "$process_pattern" || true

      local force_counter=0
      while [ "$(get_app_process_count "$process_pattern")" -gt 0 ] && [ $force_counter -lt 15 ]; do
        echo -n "."
        sleep 0.2
        force_counter=$((force_counter + 1))
      done
      echo ""

      final_check=$(get_app_process_count "$process_pattern")
      if [ "$final_check" -gt 0 ] 2>/dev/null; then
        if [ -n "$quit_error" ]; then
          print_error "$quit_error"
        fi
        echo -e "\033[1;33mWARNING: ${app_name}を強制終了できませんでした。設定をスキップします\033[0m"
        return 1
      fi
    fi
  fi
  return 0
}

# 元々起動していた場合はアプリを再起動
# 引数: $1 = アプリ名 (例: Rectangle)
# 環境変数: APP_WAS_RUNNING を参照
restart_app_if_was_running() {
  local app_name="$1"

  if [ "$APP_WAS_RUNNING" -gt 0 ] 2>/dev/null; then
    echo "${app_name}を再起動します..."
    /usr/bin/open -a "$app_name" || true
  fi
}
