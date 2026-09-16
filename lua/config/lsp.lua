vim.lsp.config.yamlls = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
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
}

vim.lsp.config.lua_ls = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
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

vim.lsp.config.clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--fallback-style=llvm",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    "CMakeLists.txt",
    "Makefile",
    ".git",
  },
}

vim.lsp.enable({ "yamlls", "pyright", "ruff", "lua_ls", "clangd" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
    if client.name == "clangd" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
    if client:supports_method("textDocument/signatureHelp") and not vim.b[args.buf].sighelp then
      vim.b[args.buf].sighelp = true
      -- clangd also advertises { } < > as triggers, which fire constantly on
      -- templates and blocks; ( and , are the ones that mean "you are in a call"
      vim.api.nvim_create_autocmd("InsertCharPre", {
        buffer = args.buf,
        callback = function()
          if vim.v.char ~= "(" and vim.v.char ~= "," then
            return
          end
          vim.defer_fn(function()
            if vim.fn.mode() ~= "i" or vim.fn.pumvisible() == 1 then
              return
            end
            vim.lsp.buf.signature_help({ focusable = false, border = "rounded", silent = true })
          end, 120)
        end,
      })
    end
  end,
})
