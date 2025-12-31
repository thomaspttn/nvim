local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader key is set in init.lua before any plugins load

-- General mappings
map("n", "<leader>x", ":bd<CR>", opts) -- Close buffer
map("n", "<leader>q", ":wq<CR>", opts) -- Quit Vim
map("n", "<leader>a", "ggVG", opts) -- Select all text in the buffer

-- Buffer navigation using Tab and Shift-Tab
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Telescope mappings
map("n", "<leader>f", ":Telescope find_files<CR>", opts) -- Fuzzy search git files
map("n", "<leader>w", ":Telescope live_grep<CR>", opts)  -- Fuzzy search with live grep
map("n", "<leader>z", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- LSP mappings
map("n", "gd", ":Telescope lsp_definitions<CR>", opts)                 -- Go to definition with Telescope
map("n", "gr", ":Telescope lsp_references<CR>", opts)                  -- Go to references with Telescope
map("n", "e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)        -- Show diagnostics
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Code action

-- Productivity suggestions
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)   -- Code action
map("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Show hover info

-- Quick fix and diagnostics
map("n", "<leader>d", "<cmd>Telescope diagnostics<CR>", opts) -- Telescope diagnostics view

-- Copilot mappings
vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false, silent = true })

-- Git mappings with Neogit
map("n", "<leader>g", ":Neogit<CR>", opts) -- Open Neogit (status view)

-- toggle highlight search
map("n", "<leader>h", ":set hlsearch!<CR>", opts)

-- switch with CTRL+hjkl for window navigation
map("n", "<C-h>", "<C-w>h", opts) -- Move to left window
map("n", "<C-j>", "<C-w>j", opts) -- Move to bottom window
map("n", "<C-k>", "<C-w>k", opts) -- Move to top window
map("n", "<C-l>", "<C-w>l", opts) -- Move to right window

-- git conflict
map("n", "<leader>co", ":GitConflictChooseOurs<CR>", opts) -- Choose 'ours' in git conflict
map("n", "<leader>ct", ":GitConflictChooseTheirs<CR>", opts) -- Choose 'theirs' in git conflict


-- Show diagnostics in a floating window on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = "",
      scope = "cursor",
    })
  end,
})
