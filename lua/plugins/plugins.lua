return {
    -- Replace vim-fugitive with Neogit for Git integration
    {
        "TimUntersberger/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                integrations = { diffview = true }, -- optional, if you want diffview support
            })

            -- Keybindings for Neogit
            vim.api.nvim_set_keymap("n", "<leader>gs", ":Neogit<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>gc", ":Neogit commit<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>gp", ":Neogit push<CR>", { noremap = true, silent = true })
        end,
    },

    -- which-key for keybindings
    {"folke/which-key.nvim"},

    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        event = "BufRead",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "lua", "python", "typescript", "javascript", "html", "yaml", "markdown", "go", "rust"}, 
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },

    -- nvim-cmp for autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            -- Define border
            local function border(hl_name)
                return {
                    { "╭", hl_name },
                    { "─", hl_name },
                    { "╮", hl_name },
                    { "│", hl_name },
                    { "╯", hl_name },
                    { "─", hl_name },
                    { "╰", hl_name },
                    { "│", hl_name },
                }
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = {
                        border = border("CmpBorder"),
                        winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
                        scrollbar = false,
                    },
                    documentation = {
                        border = border("CmpDocBorder"),
                        winhighlight = "Normal:CmpDoc",
                    },
                },
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }),
            })

            -- Command line completions
            cmp.setup.cmdline(":", {
                sources = {
                    { name = "path" },
                    { name = "cmdline" },
                },
            })
        end,
    },

    -- LSP Configuration
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "terraformls", "yamlls", "pyright", "gopls", "rust_analyzer" },
                automatic_installation = false, -- Prevent auto-configuration
            })
        end,
    },

    -- Telescope for fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        config = function()
            require("telescope").setup {
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "-L",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                    sorting_strategy = "ascending", -- Ascend through results (Tab moves down)
                    mappings = {
                        i = {
                            ["<C-n>"] = require("telescope.actions").move_selection_next,
                            ["<C-p>"] = require("telescope.actions").move_selection_previous,
                        },
                    },
                },
            }
        end,
    },

    -- Copilot integration
    {
        "github/copilot.vim",
        lazy = false,
        config = function()  -- Mapping tab is already used by NvChad
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.g.copilot_tab_fallback = ""
        end,
    },

    -- i love cats
    {
        "catppuccin/nvim",
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
            })
            vim.cmd("colorscheme catppuccin")
        end,
    },

    -- Bufferline for managing buffers
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "BufWinEnter",
        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    offsets = { { filetype = "NvimTree", text = "File Explorer", padding = 1 } },
                    show_buffer_close_icons = false,
                    show_close_icon = false,
                    separator_style = "slant",
                },
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({})
        end,
    },

    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").add_default_mappings()
        end,
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim" },
        },
        build = "make tiktoken",
        opts = {},
    },
}
