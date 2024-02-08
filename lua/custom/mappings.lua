---@type MappingsTable
local M = {}

M.general = {
    n = {
        ["<leader>rn"] = { "<cmd> lua vim.lsp.buf.rename() <CR>", "Vim LSP Rename" },
        ["<leader>fmt"] = { "<cmd> lua vim.lsp.buf.format() <CR>", "Vim LSP Format" },
    },
    v = {
        [">"] = { ">gv", "indent"},
    },
}
--
-- M.nvterm = {
--     -- new
--     ["<leader>h"] = {
--       function()
--         require("nvterm.terminal").toggle "horizontal"
--       end,
--       "New horizontal term",
--     },
--
--     ["<leader>v"] = {
--       function()
--         require("nvterm.terminal").toggle "vertical"
--       end,
--       "New vertical term",
--     },
--     ["<leader>i"] = {
--       function()
--         require("nvterm.terminal").toggle "float"
--       end,
--       "New vertical term",
--     },
-- }

-- more keybinds!

return M
