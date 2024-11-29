return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    lazy = false,
    config = function(_, opts)
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
      lspconfig.ts_ls.setup {
        settings = {
          ts_ls = { formatter = { command = "prettierd" } }
        }
      }
      lspconfig.nil_ls.setup {
        settings = {
          nil_ls = { formatter = { command = "nixfmt" } },
        },
      }

      for server, config in pairs(opts.servers or {}) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

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
}
