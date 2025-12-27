-- :HealthCheck - Health check結果を一時ファイルに保存

-- ベースディレクトリを取得（現在のバッファーまたはカレントディレクトリ）
local function get_base_dir()
  local bufpath = vim.api.nvim_buf_get_name(0)
  if bufpath ~= "" then
    return vim.fn.fnamemodify(bufpath, ":p:h")
  end
  return vim.fn.getcwd()
end

-- gitルートディレクトリを検索
local function find_git_root(dir)
  local cmd = string.format("git -C %s rev-parse --show-toplevel 2>/dev/null", vim.fn.shellescape(dir))
  local result = vim.fn.systemlist(cmd)
  return result[1] or nil
end

-- tmpディレクトリを確保（存在しない場合は作成）
local function ensure_tmp_dir(base_dir)
  local tmp_dir = base_dir .. "/tmp"
  if vim.fn.isdirectory(tmp_dir) == 0 then
    vim.fn.mkdir(tmp_dir, "p")
  end
  return tmp_dir
end

-- 保存先ディレクトリを決定
local function get_output_dir()
  local base_dir = get_base_dir()
  local git_root = find_git_root(base_dir)

  -- git管理下の場合はgitルートを使用
  if git_root then
    base_dir = git_root
  end

  return ensure_tmp_dir(base_dir)
end

-- Health check実行と結果保存
local function run_health_check(plugin)
  -- 実行開始通知（即座に表示）
  vim.notify("Running health check...", vim.log.levels.INFO)

  -- 実行日時を取得 (YYYYMMDDhhmm形式)
  local timestamp = os.date("%Y%m%d%H%M")
  local output_dir = get_output_dir()
  local output_file = string.format("%s/nvim-health-%s.txt", output_dir, timestamp)

  -- checkhealth コマンド構築
  local check_cmd = plugin and string.format("+checkhealth\\ %s", plugin) or "+checkhealth"

  -- nvim headlessコマンドで実行
  local nvim_cmd = string.format(
    "nvim --headless %s '+w!%s' +qa",
    check_cmd,
    vim.fn.shellescape(output_file)
  )

  -- headlessモードで実行
  local result = vim.fn.system(nvim_cmd)
  local exit_code = vim.v.shell_error

  -- エラーハンドリング
  if exit_code ~= 0 then
    vim.notify(
      string.format("Health check failed (exit code: %d)", exit_code),
      vim.log.levels.ERROR
    )
    return
  end

  -- 保存完了通知
  local message = plugin
    and string.format("Health check (%s) saved to %s", plugin, output_file)
    or string.format("Health check saved to %s", output_file)
  vim.notify(message, vim.log.levels.INFO)
end

-- コマンド定義
vim.api.nvim_create_user_command("HealthCheck", function(opts)
  local plugin = opts.args ~= "" and opts.args or nil
  run_health_check(plugin)
end, {
  nargs = "?",
  desc = "Run health check and save to /tmp/nvim-health.txt",
})
