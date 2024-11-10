local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

-- Terraform LSP setup
lspconfig.terraformls.setup({
    on_attach = function(client, bufnr)
        -- Set up Terraform-specific key mappings or other settings
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
        -- Set up YAML-specific key mappings or other settings
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- Python LSP setup with Pyright for LSP features
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        -- Here you can add Python-specific key mappings
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    settings = {
        python = {
            pythonPath = "/Users/thomaspatton/miniconda3/envs/dev/bin/python",
            analysis = {
                typeCheckingMode = "off",  -- Disable type checking
                autoSearchPaths = true,
                useLibraryCodeForTypes = false,
            },
        },
    },
    root_dir = function(fname)
        return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname) or util.path.dirname(fname)
    end,
})

-- Ruff LSP for Python linting and formatting only
lspconfig.ruff.setup({
    on_attach = function(client, bufnr)
        -- Disable capabilities that overlap with Pyright
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.hoverProvider = false
    end,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})
