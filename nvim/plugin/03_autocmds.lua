Util.new_autocmd("Highlight on yank", "TextYankPost", nil, function() vim.highlight.on_yank() end)

Util.new_autocmd("Go to last location when opening a buffer", "BufReadPost", nil, function()
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  local lcount = vim.api.nvim_buf_line_count(0)
  if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
end)

Util.new_autocmd(
  "Open help pages vertically by default",
  "FileType",
  { "help", "man" },
  function() vim.cmd.wincmd("L") end
)

Util.new_autocmd("Add LSP keymaps", "LspAttach", nil, function(event)
  -- stylua: ignore start
  Util.map_keys({
    { "K",          vim.lsp.buf.hover, opts = { desc = "Hover Documentation" } },
    { "gs",         vim.lsp.buf.signature_help, opts = { desc = "Signature Documentation" } },
    { "<leader>la", vim.lsp.buf.code_action, opts = { desc = "Code Action" } },
    { "<leader>lA", vim.lsp.buf.code_action, opts = { desc = "Range Code Action" } },
    { "<leader>le", vim.diagnostic.open_float, opts = { desc = "Open diagnostic message" } },
  }, { buffer = event.buf })
  -- stylua: ignore end
end)

Util.new_autocmd(
  "Don't auto-wrap comments and don't insert comment leader after hitting 'o'",
  "FileType",
  nil,
  function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end
)
