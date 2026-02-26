Pack.later(function()
  Pack.add({ "https://github.com/stevearc/conform.nvim" })

  local Conform = require("conform")

  Conform.setup({
    formatters_by_ft = {
      ["*"] = { "trim_whitespace" },
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      nix = { "nixfmt" },
      python = { "ruff_format" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      sh = { "beautysh" },
      bash = { "beautysh" },
      zsh = { "beautysh" },
    },
  })

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  local function format() Conform.format({ lsp_fallback = true }) end

  Util.map_keys({
    { "<leader>ff", format, opts = { desc = "Format File" } },
  })
end)
