-- Vim Config
vim.g.mapleader = " "
vim.g.autoformat = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autochdir = true
vim.opt.rnu = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.clipboard = "unnamedplus"

-- Keybindings
local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

map("n", "<C-h>", "<CMD>wincmd h<CR>", opts)
map("n", "<C-k>", "<CMD>wincmd k<CR>", opts)
map("n", "<C-l>", "<CMD>wincmd l<CR>", opts)
map("n", "<C-j>", "<CMD>wincmd j<CR>", opts)
map("n", "<CR>", "<CMD>noh<CR><CR>", opts)

-- Clipboard
local osc52 = require("vim.ui.clipboard.osc52")
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = {
    ["+"] = osc52.paste("+"),
    ["*"] = osc52.paste("*"),
  },
}

vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=200 })
  augroup END
]])

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim" },
    { import = "plugins" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  checker = { enabled = true, notify = false },
})

vim.cmd([[colorscheme tokyonight]])
