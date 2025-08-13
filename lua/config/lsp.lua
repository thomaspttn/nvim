local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

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

lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  settings = {
    python = {
      pythonPath = "~/miniconda3/envs/dev/bin/python",
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = false,
      },
    },
  },
  root_dir = function(fname)
    return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname) or
    util.path.dirname(fname)
  end,
})

-- Ruff LSP for Python linting and formatting only
lspconfig.ruff.setup({
  cmd = { "ruff", "server", "--preview" },
  root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
})
