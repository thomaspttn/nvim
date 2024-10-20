-- Auto resize panes when resizing nvim window
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "tabdo wincmd =",
})

-- Disable the Neovim intro message
vim.opt.shortmess:append("I")

-- Global settings for indentation (4 spaces)
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.scrolloff = 8

-- Enable line numbers, but not relative
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"


-- Use the system clipboard for all operations
vim.opt.clipboard = "unnamedplus"


-- Use 2 spaces for specific file types (typescript, javascript, react, lua)
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"typescript", "javascript", "javascriptreact", "typescriptreact", "lua"},
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
    end,
})

-- Enable colors
vim.o.termguicolors = true

-- zsh shell
vim.o.shell = '/bin/zsh'


-- Format these files on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.c", "*.cpp", "*.h", "*.hpp", "*.rs", "*.cu", "*.py"},
    callback = function()
        vim.lsp.buf.format()
    end,
})