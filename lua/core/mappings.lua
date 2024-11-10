local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Set the leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General mappings
map("n", "<leader>x", ":bd<CR>", opts)           -- Close buffer
map("n", "<leader>w", ":w<CR>", opts)            -- Save
map("n", "<leader>q", ":q<CR>", opts)            -- Quit

-- Buffer navigation using Tab and Shift-Tab
map("n", "<Tab>", ":bnext<CR>", opts)
map("n", "<S-Tab>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", opts)

-- Telescope mappings
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)   -- Find files
map("n", "<leader>fw", ":Telescope live_grep<CR>", opts)    -- Fuzzy search with live grep
map("n", "<leader>fz", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- LSP mappings
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)   -- Go to definition
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)   -- Go to references

-- Productivity suggestions
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)   -- Rename symbol
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)   -- Code action
map("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)    -- Show hover info

-- Quick fix and diagnostics
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)    -- Go to previous diagnostic
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)    -- Go to next diagnostic
map("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", opts)    -- Telescope diagnostics view

-- Copilot mappings
map("i", "<C-l>", "<cmd>lua vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')<CR>", opts)

-- Git mappings with Fugitive
map("n", "<leader>gs", ":Git<CR>", opts)                  -- Open Git status
map("n", "<leader>gl", ":Git log<CR>", opts)              -- Show Git log
map("n", "<leader>gd", ":Gdiffsplit<CR>", opts)           -- Open a diff of changes
map("n", "<leader>gb", ":Git blame<CR>", opts)            -- Git blame on the current file
map("n", "<leader>gp", ":Git push<CR>", opts)             -- Push changes
map("n", "<leader>gr", ":Git pull<CR>", opts)             -- Pull latest changes
map("n", "<leader>gc", ":Git commit<CR>", opts)           -- Open commit prompt
map("n", "<leader>ga", ":Git add %:p<CR>", opts)          -- Stage current file
map("n", "<leader>gaa", ":Git add .<CR>", opts)           -- Stage all changes
map("n", "<leader>gm", ":Git merge<CR>", opts)            -- Merge branches
map("n", "<leader>gR", ":Git reset<CR>", opts)            -- Reset changes (interactive)
map("n", "<leader>gh", ":diffget //2<CR>", opts)          -- Get change from left pane in merge conflicts
map("n", "<leader>gl", ":diffget //3<CR>", opts)          -- Get change from right pane in merge conflicts
map("n", "<leader>gt", ":Git stash<CR>", opts)            -- Stash changes
map("n", "<leader>gT", ":Git stash pop<CR>", opts)        -- Apply stashed changes
map("n", "<leader>gB", ":Git branch<CR>", opts)           -- List and manage branches

-- Saucy one-liner aliases
map("n", "<leader>gw", ":Git write<CR>", opts)            -- Quickly stage and commit with Fugitive’s ":Git write"
map("n", "<leader>g!", ":Git push --force<CR>", opts)     -- Force push (use with care)
map("n", "<leader>gU", ":Git pull --rebase<CR>", opts)    -- Pull with rebase to keep a clean history
