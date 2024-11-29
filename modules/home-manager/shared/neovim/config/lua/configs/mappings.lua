require "nvchad.mappings"

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

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
map("n", "<CR>", "<CMD>noh<CR><CR>", opts)

-- Terminal
map({ "n", "t" }, "<C-t>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal Toggle Floating Term" })

map({ "n" }, "<leader>gg", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm-git", cmd = 'lazygit' }
end, { desc = "terminal Toggle LazyGit" })
-- map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "lazygit Launch LazyGit" })

-- Telescope
map("n", "<leader>fp", "<cmd>Telescope find_files<cr>", { desc = "telescope Find Files" })
map("n", "<leader>fi", "<cmd>Telescope live_grep<CR>", { desc = "telescope Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope Find Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope Help Page" })
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope Find Marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope Find Oldfiles" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope Find All Files" }
)
map("n", "<leader>ft", function()
  require("nvchad.themes").open()
end, { desc = "telescope Show Themes" })
