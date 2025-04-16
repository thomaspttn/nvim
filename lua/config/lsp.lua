local lspconfig = require("lspconfig")
local util = require("lspconfig/util")

-- Terraform LSP setup
-- lspconfig.terraformls.setup({
--     on_attach = function(client, bufnr)
--         -- Optional: Bind `terraform fmt` to a keymap for flexibility
--         -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tf", ":silent !terraform fmt %<CR>", { noremap = true, silent = true })
--         -- Enable LSP-based formatting
--         if client.server_capabilities.documentFormattingProvider then
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 buffer = bufnr,
--                 callback = function()
--                     vim.lsp.buf.format()
--                 end,
--             })
--         end
--     end,
--     capabilities = capabilities,
-- })

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
        return util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname) or util.path.dirname(fname)
    end,
})

-- Ruff LSP for Python linting and formatting only
lspconfig.ruff.setup({})

-- Rust LSP setup
-- lspconfig.rust_analyzer.setup({
--     capabilities = capabilities,
--     settings = {
--         ['rust-analyzer'] = {
--             checkOnSave = {
--                 command = "check"
--             },
--             diagnostics = {
--                 disabled = { "unresolved-proc-macro", "clippy:all" }
--             },
--             imports = {
--                 granularity = {
--                     group = "module"
--                 }
--             },
--             inlayHints = {
--                 enable = true, -- enable inlay hints
--                 typeHints = true, -- show type hints for variables and function return types
--                 parameterHints = true, -- show parameter hints in function calls
--                 chainingHints = true, -- show type hints for chained expressions
--                 maxLength = 25 -- optional: set max length for hints
--             }
--         }
--     }
-- })

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- keybindings for Rust tools
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, opts)
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, opts)
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy"
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
          typeHints = {
            enable = true
          },
          parameterHints = {
            enable = true
          }
        }
      }
    }
  }
})
