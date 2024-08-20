-- Auto resize panes when resizing nvim window
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- Set tab width to 4 spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Use spaces instead of tabs
vim.o.expandtab = true

-- Enable colors
vim.o.termguicolors = true

-- Bash shell
vim.o.shell = '/bin/bash'

-- Format these files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.c,*.cpp,*.h,*.hpp,*.rs,*.cu,*.py",
  callback = function()
    vim.lsp.buf.format()
  end,
})
