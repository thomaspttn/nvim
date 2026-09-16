-- Force-kill LSP clients on exit so :q doesn't hang
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    for _, client in ipairs(vim.lsp.get_clients()) do
      client:stop(true)
    end
  end,
})

-- Auto resize panes when resizing nvim window
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- open nvimtree and leader f on startup
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     -- check if there are no arguments
--     if #vim.fn.argv() == 0 and vim.fn.argc() == 0 then
--       require('telescope.builtin').find_files()
--     end
--   end,
-- })

-- Disable the Neovim intro message
vim.opt.shortmess:append("I")

-- no swapfiles
vim.opt.swapfile = false

-- yolo
vim.g.loaded_python3_provider = 0

-- Global settings for indentation (4 spaces)
vim.o.updatetime = 300
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.scrolloff = 8

-- Enable line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"

-- set clipboard osc
vim.o.clipboard = 'unnamedplus'
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Use the system clipboard for all operations
vim.o.showtabline = 2     -- always show tabline
vim.opt.incsearch = true  -- incremental search
vim.opt.hlsearch = true   -- highlight search results
vim.opt.ignorecase = true -- ignore case in search
vim.opt.smartcase = true  -- smart case search

vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',   -- show tabs with arrow
  trail = '·',  -- shows trailing spaces
  space = '·'   -- optional: to show all spaces (can get noisy)
}

-- Use 2 spaces for specific file types (typescript, javascript, react, lua)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "javascript", "javascriptreact", "typescriptreact", "lua", "terraform" },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.expandtab = true
  end,
})

-- popup carries the docs; noinsert preselects without committing
vim.o.completeopt = "menu,menuone,noinsert,popup"

-- :make compiles the current file with the checks that actually catch leetcode
-- bugs: asan/ubsan for memory and overflow, hardening so v[i] is bounds-checked
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.bo.makeprg = table.concat({
      "clang++ -std=c++20 -g -O1 -Wall -Wextra -Wshadow",
      "-fsanitize=address,undefined",
      "-D_LIBCPP_HARDENING_MODE=_LIBCPP_HARDENING_MODE_DEBUG",
      "-I" .. vim.fn.expand("~/Library/Preferences/clangd/include"),
      "% -o /tmp/%:t:r",
    }, " ")
  end,
})

-- Enable colors
vim.o.termguicolors = true

-- zsh shell
vim.o.shell = '/bin/zsh'


-- Format these files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "*.rs", "*.cu", "*.py", "*.lua", "*.tf" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- the virtual_lines renderer emits one line per \n but hardcodes virt_lines_overflow=scroll,
-- so anything past the window edge is unreachable unless we wrap it ourselves
local function wrap_diagnostic(d)
  local msg = d.code and string.format("%s: %s", d.code, d.message) or d.message
  local info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  -- 6 for the renderer's "╰──── " gutter, 2 to keep off the edge
  local width = math.max(40, (info and info.width - info.textoff or 80) - 8)
  if vim.fn.strdisplaywidth(msg) <= width then
    return msg
  end
  local lines, line = {}, ""
  for word in msg:gmatch("%S+") do
    if line == "" then
      line = word
    elseif vim.fn.strdisplaywidth(line .. " " .. word) <= width then
      line = line .. " " .. word
    else
      lines[#lines + 1] = line
      line = word
    end
  end
  if line ~= "" then
    lines[#lines + 1] = line
  end
  return table.concat(lines, "\n")
end

vim.diagnostic.config({
  -- virtual_lines wraps and shows every diagnostic on the line; virtual_text truncated to one
  virtual_text = false,
  virtual_lines = { current_line = true, format = wrap_diagnostic },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
