-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
-- -- Set tab width to 4 spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Use spaces instead of tabs
vim.o.expandtab = true

-- enable colors
vim.o.termguicolors = true

-- bash shell
vim.o.shell = '/bin/bash'

-- format these files on save
-- vim.cmd [[
--   augroup LspAutoFormat
--     autocmd!
--     autocmd BufWritePre *.c,*.cpp,*.h,*.hpp,*.rs,*.cu lua vim.lsp.buf.format()
--   augroup END
-- ]]

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local clang_format_file = vim.fn.findfile('.clang-format', '.;')
    if clang_format_file ~= '' then
      vim.lsp.buf.format()
    end
  end,
})

