---@type MappingsTable
local M = {}

M.general = {
    n = {
        ["<leader>rn"] = { "<cmd> lua vim.lsp.buf.rename() <CR>", "Vim LSP Rename" },
        ["<leader>fmt"] = { "<cmd> lua vim.lsp.buf.format() <CR>", "Vim LSP Format" },
        ["<leader>lsp"] = { "<cmd> LspRestart <CR>", "Vim LSP Restart" },
    },
    v = {
        [">"] = { ">gv", "indent"},
    },
}

return M
