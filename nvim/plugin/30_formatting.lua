_B.pack.now(function()
  _B.pack.add({ { src = "https://github.com/stevearc/conform.nvim" } })

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
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },
    },
  })

  local function format() require("conform").format({ lsp_fallback = true }) end

  _B.util.map_keys({
    { "<Leader>ff", format, opts = { desc = "Format File" } },
  })
end)
