local diagnostic_opts = {
  signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },
  underline = { severity = { min = "HINT", max = "ERROR" } },
  virtual_lines = false,
  update_in_insert = false,
}

Pack.later(function()
  vim.diagnostic.config(diagnostic_opts)

  -- Work around a Neovim semantic tokens bug where LspNotify can try to reset
  -- a missing per-client token state and spam errors. Treesitter handles
  -- syntax highlighting for the languages in this config, so disable LSP
  -- semantic tokens globally instead of per-server.
  vim.lsp.semantic_tokens.enable(false)

  Util.new_autocmd("Disable LSP semantic tokens", "LspAttach", nil, function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then client.server_capabilities.semanticTokensProvider = nil end
    vim.lsp.semantic_tokens.enable(false, { bufnr = event.buf })
  end)

  vim.lsp.enable({
    "eslint",
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
end)
