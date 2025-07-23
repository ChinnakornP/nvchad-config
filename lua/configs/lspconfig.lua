-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  -- "rust_analyzer",
  "lua_ls",
  "ts_ls",
  "intelephense",
  "gopls",
  "haxe_language_server",
  -- "dartls",
  "jsonls",
  "tailwindcss",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- setup astro with custom config
lspconfig.astro.setup {
  cmd = { "astro-ls", "--stdio" },
  filetypes = { "astro" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    astro = {
      completion = {
        tags = { enable = true },
        attributes = { enable = true },
      },
    },
  },
}
