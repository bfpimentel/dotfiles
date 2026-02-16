_B.util.new_autocmd(
  "Don't auto-wrap comments and don't insert comment leader after hitting 'o'",
  "FileType",
  nil,
  function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end
)

_B.util.new_autocmd("Highlight on yank", "TextYankPost", nil, function() vim.highlight.on_yank() end)

_B.util.new_autocmd("Go to last location when opening a buffer", "BufReadPost", nil, function()
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  local lcount = vim.api.nvim_buf_line_count(0)
  if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
end)

_B.util.new_autocmd("Open help pages vertically by default", "FileType", { "help", "man" }, "wincmd L")

_B.util.new_autocmd(
  "Add LSP keymaps",
  "LspAttach",
  nil,
  function(event)
    _B.util.map_keys({
      { "K", vim.lsp.buf.hover, opts = { buffer = event.buf, desc = "Hover Documentation" } },
      { "gs", vim.lsp.buf.signature_help, opts = { buffer = event.buf, desc = "Signature Documentation" } },
      { "<leader>la", vim.lsp.buf.code_action, opts = { buffer = event.buf, desc = "Code Action" } },
      { "<leader>lA", vim.lsp.buf.code_action, opts = { buffer = event.buf, desc = "Range Code Action" } },
      { "<leader>le", vim.diagnostic.open_float, opts = { buffer = event.buf, desc = "Open diagnostic message" } },
    })
  end
)
