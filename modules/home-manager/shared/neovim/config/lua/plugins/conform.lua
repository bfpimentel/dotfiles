return {
  "stevearc/conform.nvim",
  lazy = false,
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
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
    prettier = {
      require_cwd = true,
    },
  },
}
