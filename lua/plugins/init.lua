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

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

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
          on_attach = function(_, bufnr)
            local map = vim.keymap.set
            map(
              "n",
              "K",
              "<cmd>lua vim.cmd.RustLsp({ 'hover', 'actions' })<CR>",
              { buffer = bufnr, desc = "Rust Hover" }
            )
            map(
              "n",
              "<C-Space>",
              "<cmd>lua vim.cmd.RustLsp({ 'completion' })<CR>",
              { buffer = bufnr, desc = "Rust Completion" }
            )
            map(
              "n",
              "<leader>ca",
              "<cmd>lua vim.cmd.RustLsp('codeAction')<CR>",
              { buffer = bufnr, desc = "Rust Code actions" }
            )
          end,
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
}
