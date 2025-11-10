vim.lsp.enable({
  "copilot",
  "eslint",
  "go",
  "json",
  "lua",
  "nix",
  "python",
  "typescript",
  "tailwindcss",
  "yaml",
})

vim.lsp.inline_completion.enable()

vim.diagnostic.config({ virtual_text = false })
