local lspconfig = require("lspconfig")

-- Terraform LSP
lspconfig.terraformls.setup({
    on_attach = function(client, bufnr)
        -- Setup key mappings or other LSP-related configuration here
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- YAML LSP for GitHub Actions
lspconfig.yamlls.setup({
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            },
            validate = true,
            hover = true,
            completion = true,
        },
    },
    on_attach = function(client, bufnr)
        -- Setup key mappings or other LSP-related configuration here
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Python LSP (Pyright)
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        -- Setup key mappings or other LSP-related configuration here
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Ruff LSP for Python linting
lspconfig.ruff_lsp.setup({
    on_attach = function(client, bufnr)
        -- Setup key mappings or other LSP-related configuration here
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})
