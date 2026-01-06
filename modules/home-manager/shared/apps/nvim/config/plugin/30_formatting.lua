_B.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
    confirm = false,
    data = {
      lazy = { keys = { "<Leader>ff" } },
      init = function(_)
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            yaml = { "yamlfmt" },
            nix = { "nixfmt" },
            python = { "ruff_format" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            bash = { "shfmt" },
            zsh = { "shfmt" },
          },
        })
      end,
      keys = function()
        local function format() require("conform").format({ lsp_fallback = true }) end

        return {
          { "<Leader>ff", format, { desc = "Format File" } },
        }
      end,
    },
  },
})
