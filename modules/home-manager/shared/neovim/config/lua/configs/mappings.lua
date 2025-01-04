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
map({ "n" }, "<C-t>", function()
  local Terminal         = require('toggleterm.terminal').Terminal
  local terminalInstance = Terminal:new({ hidden = true })

  terminalInstance:toggle()
end, { desc = "terminal Toggle Terminal" }, opts)

map({ "n" }, "<leader>gg", function()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true })

  lazygit:toggle()
end, { desc = "terminal Toggle LazyGit" }, opts)

-- Tree
map("n", "<leader>ns", ":Neotree toggle=true source=filesystem action=focus<CR>", { desc = "tree Show Tree" }, opts)

-- LSP
map("n", "<leader>sh", vim.lsp.buf.hover, { desc = "[S]how [H]over Info" }, opts)
map("n", "<leader>gi", vim.lsp.buf.definition, { desc = "[G]o to [I]mplementation" }, opts)
map("n", "<leader>gr", vim.lsp.buf.references, { desc = "[G]o to [R]eferences" }, opts)
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" }, opts)

-- map("n", "<leader>ft", function()
--   require("nvchad.themes").open()
-- end, { desc = "telescope Show Themes" })
