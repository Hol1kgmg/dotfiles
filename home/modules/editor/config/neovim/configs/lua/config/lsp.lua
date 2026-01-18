-- LSP設定（Neovim 0.11組み込みAPI使用、nvim-lspconfig不要）

-- 設定
local LSP_CONFIG = {
  show_attach_notification = false,  -- デバッグ時はtrueに
}

-- 共通のroot_dirパターン
local git_root = vim.fs.root(0, { ".git" })

-- LSP起動時のハンドラー設定
local on_attach = function(client)
  if LSP_CONFIG.show_attach_notification then
    vim.notify(
      string.format("LSP '%s' attached", client.name),
      vim.log.levels.INFO
    )
  end
end

-- 診断表示設定
vim.diagnostic.config({
  virtual_text = {
   format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- 各言語のLSP設定（vim.lsp.config API）

-- TypeScript/TSX
vim.lsp.config.ts_ls = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", "jsconfig.json" }),
  on_attach = on_attach,
}

-- Python
vim.lsp.config.pyright = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", "requirements.txt" }),
  on_attach = on_attach,
}

-- Nix
vim.lsp.config.nixd = {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_dir = vim.fs.root(0, { "flake.nix", "default.nix", "shell.nix", ".nixd.json" }),
  on_attach = on_attach,
  settings = {
    nixd = {
      formatting = { command = { "nixfmt" } },
    },
  },
}

-- YAML
vim.lsp.config.yamlls = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_dir = git_root,
  on_attach = on_attach,
}

-- TOML
vim.lsp.config.taplo = {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_dir = vim.fs.root(0, { "*.toml" }),
  on_attach = on_attach,
  settings = {
    evenBetterToml = {
      schema = {
        associations = {
          -- .mise.toml を mise のスキーマに紐付ける
          ["\\.mise\\.toml$"] = "https://mise.jdx.dev/schema/mise.json",
          -- 必要に応じて他のファイルも追加可能
          -- ["cargo\\.toml$"] = "https://json.schemastore.org/cargo.json",
        },
      },
    },
  },
}

-- JSON
vim.lsp.config.jsonls = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_dir = git_root,
  on_attach = on_attach,
}

-- Vim
vim.lsp.config.vimls = {
  cmd = { "vim-language-server", "--stdio" },
  filetypes = { "vim" },
  root_dir = git_root,
  on_attach = on_attach,
}

-- Lua (Neovim設定対応)
vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = vim.fs.root(0, { ".luarc.json", ".luacheckrc", ".git" }),
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

-- Markdown
vim.lsp.config.marksman = {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  -- .marksman.toml優先、なければ.gitをフォールバック
  root_dir = vim.fs.root(0, { ".git", ".marksman.toml" }),
  on_attach = on_attach,
}

-- Tailwind CSS
vim.lsp.config.tailwindcss = {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  -- postcss.config.mjsを含む設定ファイルからプロジェクトルートを検出
  root_dir = vim.fs.root(0, {
    "tailwind.config.js",
    "tailwind.config.cjs",
    "tailwind.config.mjs",
    "tailwind.config.ts",
    "postcss.config.js",
    "postcss.config.mjs",
    "postcss.config.cjs"
  }),
  on_attach = on_attach,
  settings = {
    tailwindCSS = {
      -- カスタムクラス属性の補完を有効化
      classAttributes = { "class", "className", "classList", "ngClass" },
    },
  },
}

-- 全LSPサーバーを有効化
local servers = { "ts_ls", "pyright", "nixd", "yamlls", "taplo", "jsonls", "vimls", "lua_ls", "marksman", "tailwindcss" }
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

-- モジュールとしてexport（他のファイルから参照可能に）
-- テーブル形式を維持することで、将来的な拡張が容易
-- 例: diagnostic_config, on_attach, git_rootなどの共通設定も追加可能
return {
  servers = servers,
}
