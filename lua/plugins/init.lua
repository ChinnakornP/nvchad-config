return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "html",
        "css",
        "blade",
      },
    },
    config = function(_, opts)
      ---@class ParserInfo[]
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = {
            "src/parser.c",
            -- 'src/scanner.cc',
          },
          branch = "main",
          generate_requires_npm = true,
          requires_generate_from_grammar = true,
        },
        filetype = "blade",
      }

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration
        tools = {
          float_win_config = {
            border = "rounded",
          },
        },
        -- LSP configuration
        server = {
          capabilities = require("nvchad.configs.lspconfig").capabilities,
          on_attach = require("nvchad.configs.lspconfig").on_attach,
          -- on_attach = function(_, bufnr)
          --   local map = vim.keymap.set
          --   map(
          --     "n",
          --     "K",
          --     "<cmd>lua vim.cmd.RustLsp({ 'hover', 'actions' })<CR>",
          --     { buffer = bufnr, desc = "Rust Hover" }
          --   )
          --   map(
          --     "n",
          --     "<C-Space>",
          --     "<cmd>lua vim.cmd.RustLsp({ 'completion' })<CR>",
          --     { buffer = bufnr, desc = "Rust Completion" }
          --   )
          --   map(
          --     "n",
          --     "<leader>ca",
          --     "<cmd>lua vim.cmd.RustLsp('codeAction')<CR>",
          --     { buffer = bufnr, desc = "Rust Code actions" }
          --   )
          -- end,
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {},
          },
        },
        -- DAP configuration
        dap = {},
      }
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = "VeryLazy",
    config = function()
      -- dofile(vim.g.base46_cache .. "todo")
      require("todo-comments").setup {
        keywords = {
          GROUP = { icon = " ", color = "hint" },
          HERE = { icon = " ", color = "here" },
        },
        colors = { here = "#fdf5a4" },
        highlight = { multiline = true },
      }
    end,
  },
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    init = function()
      vim.keymap.set("n", "<leader>oo", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
    end,
    config = function()
      require("outline").setup {}
    end,
  },

  -- show version
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function(_, opts)
      local crates = require "crates"
      local cmp = require "cmp"

      crates.setup(opts)
      cmp.setup.buffer {
        sources = { { name = "crates" } },
      }
      crates.show()

      vim.keymap.set("n", "<leader>cu", function()
        crates.upgrade_all_crates()
      end, { desc = "Update crates" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "LspAttach",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {},
    config = function()
      local map = vim.keymap.set
      local dap = require "dap"
      local dapui = require "dapui"
      local widgets = require "dap.ui.widgets"
      local sidebar = widgets.sidebar(widgets.scopes)

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "DAP Toggle breakpoint" })
      map("n", "<leader>dt", function()
        sidebar.toggle()
      end, { desc = "DAP Toggle sidebar" })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
    init = function()
      local map = vim.keymap.set
      map("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
      map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })
    end,
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install "go"
    end,
    config = function()
      require("dbee").setup(--[[optional config]])
    end,
  },
  {
    "rest-nvim/rest.nvim",
  },
  {
    "f-person/git-blame.nvim",
    -- load the plugin at startup
    event = "VeryLazy",
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    opts = {
      -- your configuration comes here
      -- for example
      enabled = true, -- if you want to enable the plugin
      message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
      date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
      virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
    },
  },
  -- for dart syntax hightling
  {
    "dart-lang/dart-vim-plugin",
  },
}
