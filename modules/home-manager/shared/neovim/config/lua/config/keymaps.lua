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

-- Clipboard
-- map("n", "p", '"+p')
-- map("n", "P", '"+P')
-- map("n", "dd", '"+dd')
-- map({ "n", "v" }, "d", '"+d')
-- map({ "n", "v" }, "y", '"+y')
-- map({ "n", "v" }, "Y", '"+yy')
-- map({ "n", "v" }, "x", '"+x')
-- map({ "n", "v" }, "X", '"+X')

-- Formatting
map("n", "<leader>ff", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general Format File" })

-- Window
map("n", "<C-h>", "<CMD>wincmd h<CR>", with_default_opts({}))
map("n", "<C-k>", "<CMD>wincmd k<CR>", with_default_opts({}))
map("n", "<C-l>", "<CMD>wincmd l<CR>", with_default_opts({}))
map("n", "<C-j>", "<CMD>wincmd j<CR>", with_default_opts({}))

-- Search
map("n", "<Esc>", "<CMD>nohlsearch<CR><CR>", with_default_opts({}))

-- map("n", "<leader>ft", function()
--   require("nvchad.themes").open()
-- end, { desc = "telescope Show Themes" })
