Pack.later(function()
  Pack.add({ "https://github.com/stevearc/conform.nvim" })

  local Conform = require("conform")

  Conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      nix = { "nixfmt" },
      python = { "ruff_format" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
    },
  })

  local function format() Conform.format({ lsp_fallback = true }) end

  Util.map_keys({
    { "<leader>ff", format, opts = { desc = "Format File" } },
  })
end)
