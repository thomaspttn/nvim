-- Auto resize panes when resizing nvim window
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "tabdo wincmd =",
})

-- open leader f on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- check if there are no arguments
    if #vim.fn.argv() == 0 and vim.fn.argc() == 0 then
      require('telescope.builtin').git_files()
    end
  end,
})

-- Disable the Neovim intro message
vim.opt.shortmess:append("I")

-- no swapfiles
vim.opt.swapfile = false

-- yolo
vim.g.loaded_python3_provider = 0

-- Global settings for indentation (4 spaces)
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.scrolloff = 8

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"

-- Use the system clipboard for all operations
vim.opt.clipboard = "unnamedplus"

vim.o.showtabline = 2 -- always show tabline

vim.opt.list = true
vim.opt.listchars = {
  tab = '▸ ',       -- or '⇥ ' or '→ ' if you prefer
  trail = '·',      -- shows trailing spaces
  extends = '⟩',    -- when text extends beyond window
  precedes = '⟨',   -- when text precedes window
  space = '·'       -- optional: to show all spaces (can get noisy)
}

-- Use 2 spaces for specific file types (typescript, javascript, react, lua)
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"typescript", "javascript", "javascriptreact", "typescriptreact", "lua", "terraform"},
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
    pattern = {"*.c", "*.cpp", "*.h", "*.hpp", "*.rs", "*.cu", "*.py", "*.lua", "*.tf"},
    callback = function()
        vim.lsp.buf.format()
    end,
})
