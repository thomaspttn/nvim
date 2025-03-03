local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Set the leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General mappings
map("n", "<leader>x", ":bd<CR>", opts)           -- Close buffer

-- Buffer navigation using Tab and Shift-Tab
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Telescope mappings
map("n", "<leader>f", ":Telescope find_files<CR>", opts)   -- Find files
map('n', '<leader>o', "<cmd>lua require('telescope.builtin').oldfiles()<CR>", opts)   -- Open old files
map("n", "<leader>w", ":Telescope live_grep<CR>", opts)    -- Fuzzy search with live grep
map("n", "<leader>z", ":Telescope current_buffer_fuzzy_find<CR>", opts)
map("n", "<leader>b", ":Telescope file_browser<CR>", opts)
map("n", "<leader>c", ":ChatGPT<CR>", opts)    -- ChatGPT

-- LSP mappings
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)   -- Go to definition
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)   -- Go to references
map("n", "e",  "<cmd>lua vim.diagnostic.open_float()<CR>", opts)   -- Show diagnostics

-- Productivity suggestions
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)   -- Rename symbol
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)   -- Code action
map("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)    -- Show hover info

-- Quick fix and diagnostics
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)    -- Go to previous diagnostic
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)    -- Go to next diagnostic
map("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opts)    -- Telescope diagnostics view

-- Copilot mappings
map("i", "<C-l>", "<cmd>lua vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')<CR>", opts)

-- Git mappings with Neogit
map("n", "<leader>g", ":Neogit<CR>", opts)                -- Open Neogit (status view)
