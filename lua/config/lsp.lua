local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Merge LSP capabilities with nvim-cmp for better completions
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

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
  capabilities = capabilities,
})

lspconfig.pyright.setup({
  capabilities = capabilities,
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
  capabilities = capabilities,
  root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
})

-- Lua LSP for Neovim config editing
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})
