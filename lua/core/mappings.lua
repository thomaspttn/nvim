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
map("n", "e", "<cmd>lua vim.diagnostic.open_float(nil, { scope = 'line' })<CR>", opts)
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- Code action

-- Productivity suggestions
-- map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)   -- Code action
map("n", "<leader>k", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Show hover info

-- Quick fix and diagnostics
map("n", "<leader>d", "<cmd>Telescope diagnostics<CR>", opts) -- Telescope diagnostics view

-- ex-copilot accept key; unmapped it inserts a literal ^L
vim.keymap.set("i", "<C-l>", "<Nop>", { silent = true })

-- native completion accepts with <C-y>; vscode accepts with tab, and with enter
-- in addition. fall through to a literal key when the popup is closed.
for lhs in pairs({ ["<Tab>"] = true, ["<CR>"] = true }) do
  vim.keymap.set("i", lhs, function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or lhs
  end, { expr = true, silent = true })
end

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


-- open the docs for whatever check is complaining under the cursor
vim.keymap.set("n", "<leader>?", function()
  local d = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })[1]
  if not d then
    return vim.notify("no diagnostic on this line", vim.log.levels.INFO)
  end
  local code = tostring(d.code or "")
  local group, check = code:match("^([%a%d]+)%-(.+)$")
  if d.source == "clang-tidy" and group then
    vim.ui.open(("https://clang.llvm.org/extra/clang-tidy/checks/%s/%s.html"):format(group, check))
  else
    vim.ui.open("https://duckduckgo.com/?q=" .. vim.uri_encode("c++ " .. (code ~= "" and code or d.message)))
  end
end, { silent = true, desc = "Explain diagnostic under cursor" })
