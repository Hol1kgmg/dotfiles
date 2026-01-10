-- Floatウィンドウ表示ユーティリティ

local M = {}

---@class FloatWindowOpts
---@field title? string ウィンドウタイトル
---@field filetype? string バッファのfiletype
---@field width? number 固定幅（省略時は自動計算）
---@field max_width? number 最大幅（デフォルト: 100）
---@field min_width? number 最小幅（デフォルト: 50）
---@field max_height? number 最大高さ（デフォルト: 30）

--- Floatウィンドウで情報を表示
---@param lines string[] 表示する行
---@param opts? FloatWindowOpts オプション
function M.show(lines, opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  if opts.filetype then
    vim.bo[buf].filetype = opts.filetype
  end

  -- ウィンドウサイズ計算
  local max_width = opts.max_width or 100
  local min_width = opts.min_width or 50
  local max_height = opts.max_height or 30

  local width
  if opts.width then
    width = opts.width
  else
    local content_width = 0
    for _, line in ipairs(lines) do
      content_width = math.max(content_width, #line)
    end
    width = math.min(max_width, math.max(min_width, content_width + 4))
  end

  local height = math.min(max_height, #lines)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  if opts.title then
    win_opts.title = opts.title
    win_opts.title_pos = "center"
  end

  vim.api.nvim_open_win(buf, true, win_opts)

  -- q または Esc で閉じる
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

return M
