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

-- libc++ headers carry no doc comments, so hover gives you a signature and
-- nothing else. clangd's hover does name the container ("// In queue<int>"),
-- which is enough to rebuild a qualified name and hand it to cppman.
local function cppreference()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    return
  end
  vim.lsp.buf_request(0, "textDocument/hover", vim.lsp.util.make_position_params(0, "utf-16"),
    function(_, result)
      local contents = result and result.contents
      local text = type(contents) == "table" and (contents.value or contents[1]) or contents
      local class = text and tostring(text):match("// In ([%w_]+)")
      if class == "namespace" then
        class = nil -- "// In namespace std" means a free function, not a member
      end
      local query = class and ("std::%s::%s"):format(class, word)
        or (word:find("::") and word or "std::" .. word)
      local width = math.max(60, vim.api.nvim_win_get_width(0) - 4)
      vim.system({ "cppman", query }, { text = true, env = { COLUMNS = tostring(width) } },
        function(out)
          vim.schedule(function()
            local body = (out.stdout or ""):gsub("\r", "")
            if out.code ~= 0 or body:match("^%s*$") then
              vim.notify("no cppreference page for " .. query, vim.log.levels.WARN)
              return
            end
            vim.cmd("botright 22new")
            local buf = vim.api.nvim_get_current_buf()
            vim.bo[buf].buftype = "nofile"
            vim.bo[buf].bufhidden = "wipe"
            vim.bo[buf].swapfile = false
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(body, "\n"))
            vim.bo[buf].modifiable = false
            vim.bo[buf].filetype = "man"
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
          end)
        end)
    end)
end

vim.keymap.set("n", "<leader>m", cppreference, { desc = "cppreference page for symbol" })
