local K = require("utils.keys")

vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/esmuellert/nvim-eslint" },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yamlfmt" },
    nix = { "nixfmt" },
    python = { "ruff" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
  },
  prettier = {
    require_cwd = true,
    prepend_args = { "--print-width=120" },
  },
})

local Eslint = require("nvim-eslint")
local Blink = require("blink.cmp")

local capabilities = Eslint.make_client_capabilities()
capabilities = Blink.get_lsp_capabilities(capabilities)

Eslint.setup({
  capabilities = capabilities,
  settings = {
    useFlatConfig = true,
    workingDirectory = { mode = "location" },
  },
})

K.map("ff", function() require("conform").format({ lsp_fallback = true }) end, { desc = "Format File" })
