local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- General
map("n", "<S-u>", "<C-r><CR>", opts)

-- Formatting
map("n", "<leader>ff", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general Format File" })

-- Window
map("n", "<C-h>", "<CMD>wincmd h<CR>", opts)
map("n", "<C-k>", "<CMD>wincmd k<CR>", opts)
map("n", "<C-l>", "<CMD>wincmd l<CR>", opts)
map("n", "<C-j>", "<CMD>wincmd j<CR>", opts)

-- Search
map("n", "<Esc>", "<CMD>nohlsearch<CR><CR>", opts)

-- Terminal
map({ "n" }, "<leader>gg", function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true })

  lazygit:toggle()
end, { desc = "terminal Toggle LazyGit" })

map("n", "<C-j>", '<CMD>exe v:count1 . "ToggleTerm"<CR>', opts)

-- Tree
map("n", "<leader>ns", ":Neotree toggle=true source=filesystem action=focus<CR>", { desc = "tree Show Tree" })

-- map("n", "<leader>ft", function()
--   require("nvchad.themes").open()
-- end, { desc = "telescope Show Themes" })
