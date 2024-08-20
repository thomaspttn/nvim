---@type MappingsTable
local M = {}

M.general = {
    n = {
        ["<leader>rn"] = { "<cmd> lua vim.lsp.buf.rename() <CR>", "Vim LSP Rename" },
        ["<leader>fmt"] = { "<cmd> lua vim.lsp.buf.format() <CR>", "Vim LSP Format" },
        ["<leader>lsp"] = { "<cmd> LspRestart <CR>", "Vim LSP Restart" },
        ["<leader>j"] = { "10j", "Move 10 lines down" }, -- Added line for leader j
        ["<leader>k"] = { "10k", "Move 10 lines up" }, -- Added line for leader k
        ["<leader>i"] = {
          function()
            require("nvterm.terminal").toggle "float"
          end,
          "Toggle floating term",
        },
        ["<C-h>"] = {
          function()
            require("nvterm.terminal").toggle "horizontal"
          end,
          "Toggle horizontal term",
        },

        ["<C-v>"] = {
          function()
            require("nvterm.terminal").toggle "vertical"
          end,
          "Toggle vertical term",
        },
    },

    v = {
        [">"] = { ">gv", "indent"},
    },
}

M.copilot = {
  i = {
    ["<C-l>"] = {
      function()
        vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
      end,
      "Copilot Accept",
       {replace_keycodes = true, nowait=true, silent=true, expr=true, noremap=true}
      }
  }
}

return M
