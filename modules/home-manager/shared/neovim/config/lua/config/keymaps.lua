local map = vim.keymap.set

local function with_default_opts(extra_opts)
  local opts = { noremap = true, silent = true }
  -- stylua: ignore
  for k, v in pairs(extra_opts) do opts[k] = v end
  return opts
end

map("n", "<leader>rr", "<CMD>restart<CR>", with_default_opts({ desc = "Restart Neovim" }))
map("n", "<S-u>", "<C-r><CR>", with_default_opts({ desc = "Redo" }))
map("n", "<Esc>", "<CMD>nohlsearch<CR><CR>", with_default_opts({ desc = "Clean Search " }))
map("n", "<C-h>", "<CMD>wincmd h<CR>", with_default_opts({ desc = "Move Cursor to Left Window" }))
map("n", "<C-j>", "<CMD>wincmd j<CR>", with_default_opts({ desc = "Move Cursor to Bottom Window" }))
map("n", "<C-k>", "<CMD>wincmd k<CR>", with_default_opts({ desc = "Move Cursor to Top Window" }))
map("n", "<C-l>", "<CMD>wincmd l<CR>", with_default_opts({ desc = "Move Cursor to Right Window" }))
