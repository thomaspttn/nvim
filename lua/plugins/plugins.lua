return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 0
      vim.g.everforest_disable_italic_comment = 1
      vim.g.everforest_better_performance = 1
      vim.o.background = "dark"
      vim.cmd("colorscheme everforest")
    end,
  },

  {
    "TimUntersberger/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = "Neogit",
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        integrations = { diffview = false },
      })
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    auto_format = true,
    auto_focus = true,
    config = function()
      vim.g.rustaceanvim = {
        server = {
          settings = {
            ["rust-analyzer"] = {
              completion = {
                snippets = "none" -- Disable snippets entirely
              }
            }
          }
        }
      }
    end,
  },

  -- which-key for keybindings
  { "folke/which-key.nvim", event = "VeryLazy" },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      local want = {
        "bash", "c", "cpp", "go", "html", "javascript", "lua", "markdown",
        "markdown_inline", "python", "rust", "terraform", "toml", "typescript",
        "vim", "vimdoc", "yaml",
      }
      local have = require("nvim-treesitter.config").get_installed("parsers")
      local missing = vim.tbl_filter(function(p)
        return not vim.tbl_contains(have, p)
      end, want)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufRead",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
      })

      local objects = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["as"] = "@statement.outer",
        ["is"] = "@statement.inner",
      }
      for lhs, obj in pairs(objects) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          require("nvim-treesitter-textobjects.select").select_textobject(obj, "textobjects")
        end, { desc = "textobject " .. obj })
      end
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
          file_ignore_patterns = {
            "^%.git/", -- .git directory (but not .github)
            "^%.venv/", "/%.venv/",
            "^venv/", "/venv/",
            "^target/", "/target/", -- Rust build
            "^node_modules/", "/node_modules/",
            "^__pycache__/", "/__pycache__/",
            "%.pyc$",
          },
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--no-ignore",
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
            width = 0.95,
            height = 0.80,
            preview_cutoff = 120,
          },
          sorting_strategy = "ascending", -- Ascend through results (Tab moves down)
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
          },
        },
      }
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({ check_ts = true })
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
    event = "BufRead",
    config = function()
      require("gitsigns").setup({})
    end,
  },

  -- Git conflict markers
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufRead",
    config = function()
      require("git-conflict").setup()
    end,
  },

  -- leap.nvim for enhanced navigation
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    event = "VeryLazy",
    config = function()
      -- Manual mappings (add_default_mappings is deprecated)
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
      vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
      vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)")
    end,
  }
}
