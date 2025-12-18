local group = vim.api.nvim_create_augroup("bfmp", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  desc = "Don't auto-wrap comments and don't insert comment leader after hitting 'o'",
  group = group,
  callback = function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = group,
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Go to last location when opening a buffer",
  group = group,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Start Treesitter when opening a buffer",
  group = group,
  callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keymaps",
  group = group,
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
    map("<leader>la", vim.lsp.buf.code_action, "Code Action")
    map("<leader>lA", vim.lsp.buf.code_action, "Range Code Action")
  end,
})

-- vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
--   group = vim.api.nvim_create_augroup("EOFScroll", {}),
--   callback = function()
--     local win_h = vim.api.nvim_win_get_height(0)
--     local off = math.min(vim.o.scrolloff, math.floor(win_h / 2))
--     local dist = vim.fn.line("$") - vim.fn.line(".")
--     local rem = vim.fn.line("w$") - vim.fn.line("w0") + 1
--     if dist < off and win_h - rem + dist < off then
--       local view = vim.fn.winsaveview()
--       view.topline = view.topline + off - (win_h - rem + dist)
--       vim.fn.winrestview(view)
--     end
--   end,
-- })
