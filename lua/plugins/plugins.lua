return {
    -- i love cats
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     config = function()
    --         require("catppuccin").setup({
    --             flavour = "macchiato", -- latte, frappe, macchiato, mocha
    --         })
    --         vim.cmd("colorscheme catppuccin")
    --     end,
    -- },
    {
      "rose-pine/neovim",
      name = "rose-pine",
      config = function()
        require("rose-pine").setup({
          styles = {
            bold = false,
            italic = false,
            transparency = false,
          },
        })
        vim.cmd("colorscheme rose-pine-moon")
      end,
    },

    -- maybe lets give this a shot?
    -- {
    --     "sainnhe/everforest",
    --     config = function()
    --         -- set the background to dark
    --         vim.o.background = "dark"
    --
    --         -- set the everforest background to hard
    --         vim.g.everforest_background = "hard"
    --
    --         vim.g.everforest_transparent_background = 1
    --
    --         -- enable the colorscheme
    --         vim.cmd.colorscheme("everforest")
    --     end,
    -- },
  
    {
        "TimUntersberger/neogit",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                integrations = { diffview = true }, 
            })
        end,
    },

    {
      'simrat39/rust-tools.nvim',
      requires = { 'neovim/nvim-lspconfig', 'nvim-lua/plenary.nvim' }
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
                    file_ignore_patterns = {},
                    hidden = true,
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

    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("telescope").setup({
          extensions = {
            file_browser = {
              hijack_netrw = true, -- If you want it to hijack netrw (default)
              -- any other settings you need
            }
          }
        })
        require("telescope").load_extension("file_browser")
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

    {
      {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
          { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
          { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
          -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
      },
    },

    {
      "jackMort/ChatGPT.nvim",
      event = "VeryLazy",
      config = function()
        require("chatgpt").setup({
          -- this config assumes you have OPENAI_API_KEY environment variable set
          openai_params = {
            model = "gpt-4o-mini",
            -- frequency_penalty = 0,
            -- presence_penalty = 0,
            -- max_tokens = 4095,
            -- temperature = 0.2,
            -- top_p = 0.1,
            -- n = 1,
          }
        })
      end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
          "folke/trouble.nvim", -- optional
        "nvim-telescope/telescope.nvim"
      }
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
}
