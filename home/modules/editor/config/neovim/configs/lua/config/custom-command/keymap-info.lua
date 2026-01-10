-- :KeymapInfo - キーマップ情報表示コマンド

local float_window = require("config.utils.float-window")

-- コマンド定義
vim.api.nvim_create_user_command("KeymapInfo", function(opts)
  local key = opts.args

  -- 引数がなければ入力を求める
  if key == "" then
    key = vim.fn.input("Keymap to inspect: ")
    if key == "" then return end
  end

  -- verbose nmapの出力を取得
  local output = vim.fn.execute("verbose nmap " .. key)
  local lines = vim.split(output, "\n", { trimempty = true })

  if #lines == 0 then
    lines = { "No mapping found for: " .. key }
  end

  float_window.show(lines, {
    title = " Keymap: " .. key .. " ",
    filetype = "vim",
  })
end, {
  nargs = "?",
  desc = "Show keymap definition info",
})
