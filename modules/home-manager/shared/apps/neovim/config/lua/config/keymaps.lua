local function map(key, cmd, extra_opts)
  local opts = { noremap = true, silent = true }
  for k, v in pairs(extra_opts) do
    opts[k] = v
  end

  vim.keymap.set("n", key, cmd, opts)
end

-- General
map("<leader>rr", "<CMD>restart<CR>", { desc = "Restart Neovim" })
map("<S-u>", "<C-r><CR>", { desc = "Redo" })
map("<Esc>", "<CMD>nohlsearch<CR><CR>", { desc = "Clean Search " })

-- Window
map("<C-h>", "<CMD>wincmd h<CR>", { desc = "Move Cursor to Left Window" })
map("<C-j>", "<CMD>wincmd j<CR>", { desc = "Move Cursor to Bottom Window" })
map("<C-k>", "<CMD>wincmd k<CR>", { desc = "Move Cursor to Top Window" })
map("<C-l>", "<CMD>wincmd l<CR>", { desc = "Move Cursor to Right Window" })
