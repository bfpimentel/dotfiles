vim.lsp.enable({
  -- "copilot",
  "eslint",
  "go",
  "html",
  "json",
  "lua",
  "nix",
  "python",
  "typescript",
  "tailwindcss",
  "yaml",
})

vim.lsp.inline_completion.enable()

vim.diagnostic.config({
  signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },
  -- underline = { severity = { min = "HINT", max = "ERROR" } },
  -- virtual_lines = false,
  -- virtual_text = {
  --   -- current_line = true,
  --   severity = { min = "ERROR", max = "ERROR" },
  -- },
  update_in_insert = false,
})
