local diagnostic_opts = {
  signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },
  underline = { severity = { min = "HINT", max = "ERROR" } },
  virtual_lines = false,
  update_in_insert = false,
}

Pack.later(function()
  vim.diagnostic.config(diagnostic_opts)

  vim.lsp.enable({
    "eslint",
    "fish",
    "html",
    "json",
    "lua",
    "nix",
    "oxlint",
    "python",
    "qml",
    "typescript",
    "tailwindcss",
    "yaml",
  })

  vim.lsp.inline_completion.enable()
end)
