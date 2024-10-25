return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                "vim",
                "use",
              }
            }
          }
        }
      }
      lspconfig.bashls.setup {}
      lspconfig.yamlls.setup {}
      lspconfig.clangd.setup {}
      lspconfig.ts_ls.setup {}
      lspconfig.nil_ls.setup {
        settings = {
          nil_ls = { formatter = { command = "nixfmt" } },
        },
      }

      vim.keymap.set("n", "<leader>sh", vim.lsp.buf.hover, { desc = "[S]how [H]over Info" })
      vim.keymap.set("n", "<leader>gi", vim.lsp.buf.definition, { desc = "[G]o to [I]mplementation" })
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "[G]o to [R]eferences" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    lazy = false,
    config = function()
      require("inc_rename").setup()

      vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "[R]e[n]ame" })
    end,
  },
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      {
        "<leader>ff",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat [F]ile",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "lua_ls" },
        sh = { "bashls" },
        yaml = { "yamlls" },
        nix = { "nixfmt" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
      },
    },
  },
}
