local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Set the leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General mappings
map("n", "<leader>x", ":bd<CR>", opts)
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

-- Buffer navigation using Tab and Shift-Tab
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Telescope mappings
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)  -- Find files
map("n", "<leader>fw", ":Telescope live_grep<CR>", opts)   -- Fuzzy search with live grep
map("n", "<leader>fz", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- Copilot mappings
map("i", "<C-l>", "<cmd>lua vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')<CR>", opts)



