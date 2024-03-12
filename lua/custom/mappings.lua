---@type MappingsTable
local M = {}

M.general = {
    n = {
        ["<leader>rn"] = { "<cmd> lua vim.lsp.buf.rename() <CR>", "Vim LSP Rename" },
        ["<leader>fmt"] = { "<cmd> lua vim.lsp.buf.format() <CR>", "Vim LSP Format" },
        ["<leader>lsp"] = { "<cmd> LspRestart <CR>", "Vim LSP Restart" },
        ["<leader>j"] = { "5j", "Move 5 lines down" }, -- Added line for leader j
        ["<leader>k"] = { "5k", "Move 5 lines up" }, -- Added line for leader k
    },
    v = {
        [">"] = { ">gv", "indent"},
    },
}

return M
