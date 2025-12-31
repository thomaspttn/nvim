-- LSP configuration (compatible with Neovim 0.10 and 0.11+)

-- Merge LSP capabilities with nvim-cmp for better completions
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Check if we're on Neovim 0.11+ (has vim.lsp.config)
local use_new_api = vim.lsp.config ~= nil

if use_new_api then
  -- Neovim 0.11+ native LSP configuration
  vim.lsp.config.yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
    root_markers = { ".git" },
    capabilities = capabilities,
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
  }

  vim.lsp.config.pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
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
  }

  vim.lsp.config.ruff = {
    cmd = { "ruff", "server", "--preview" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    capabilities = capabilities,
  }

  vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
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
  }

  vim.lsp.enable({ "yamlls", "pyright", "ruff", "lua_ls" })
else
  -- Neovim 0.10 and earlier - use nvim-lspconfig
  local lspconfig = require("lspconfig")
  local util = require("lspconfig.util")

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
      return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)
          or util.path.dirname(fname)
    end,
  })

  lspconfig.ruff.setup({
    cmd = { "ruff", "server", "--preview" },
    capabilities = capabilities,
    root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
  })

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
end
