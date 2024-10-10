local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "html",
    "c",
    "cpp",
    "rust",
    "markdown",
    "markdown_inline",
    "cmake",
    "python",
    "cuda",
    "terraform",
    "json",
    "yaml",
    "javascript",
    "typescript",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",
    -- c/cpp stuff
    "clangd",
    -- python
    "pyright",
    -- js/ts
    "typescript-language-server"
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
