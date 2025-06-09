local add, now = MiniDeps.add, MiniDeps.now

add({ source = "stevearc/conform.nvim" })

local Conform = require("conform")
Conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yamlfmt" },
    nix = { "nixfmt" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
  },
  prettier = {
    require_cwd = true,
  },
})

now(function()
  vim.keymap.set("n", "<leader>ff", function() Conform.format({ lsp_fallback = true }) end, { desc = "Format File" })
end)
