local map = vim.keymap.set

local function with_default_opts(extra_opts)
  local opts = { noremap = true, silent = true }

  for i = 1, #extra_opts do
    opts[#opts + 1] = extra_opts[i]
  end
  return opts
end

-- General
map("n", "<S-u>", "<C-r><CR>", with_default_opts({}))

-- Window
map("n", "<C-h>", "<CMD>wincmd h<CR>", with_default_opts({}))
map("n", "<C-k>", "<CMD>wincmd k<CR>", with_default_opts({}))
map("n", "<C-l>", "<CMD>wincmd l<CR>", with_default_opts({}))
map("n", "<C-j>", "<CMD>wincmd j<CR>", with_default_opts({}))

-- Search
map("n", "<Esc>", "<CMD>nohlsearch<CR><CR>", with_default_opts({}))
