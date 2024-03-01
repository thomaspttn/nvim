local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local utils = require "core.utils"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "pyright"}
capabilities.offsetEncoding = "utf-8"

custom_on_attach = function(client, bufnr)
  -- client.server_capabilities.documentFormattingProvider = false
  -- client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach,
    capabilities = capabilities,
  }
end


local rt = require("rust-tools")
rt.setup({
  server = {
    on_attach = custom_on_attach
  },
})
