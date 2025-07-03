return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    opts = function()
      return {
        formatters_by_ft = {
          lua = { "stylua" },
          yaml = { "yamlfmt" },
          nix = { "nixfmt" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          javascript = { "prettierd" },
          javascriptreact = { "prettierd" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
        },
        prettier = {
          require_cwd = true,
        },
      }
    end,
    keys = function()
      local Conform = require("conform")

      return {
        -- stylua: ignore start
        { "<leader>ff", function() Conform.format({ lsp_fallback = true }) end, desc = "Format File" },
        -- stylua: ignore end
      }
    end,
  },
  {
    "esmuellert/nvim-eslint",
    dependencies = {
      "saghen/blink.cmp",
    },
    ft = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    opts = function()
      local Eslint = require("nvim-eslint")
      local Blink = require("blink.cmp")

      local capabilities = Eslint.make_client_capabilities()
      capabilities = Blink.get_lsp_capabilities(capabilities)

      return {
        capabilities = capabilities,
        settings = {
          useFlatConfig = true,
          workingDirectory = { mode = "location" },
        },
      }
    end,
  },
}
