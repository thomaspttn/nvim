-- Set leader key BEFORE any plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings
require("core.settings")

-- Key mappings
require("core.mappings")

-- Lazy.nvim setup
require("config.lazy")

-- LSP configuration
require("config.lsp")

