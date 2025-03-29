vim.g.mapleader = " "

-- Vim Config
vim.g.autoformat = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.o.termguicolors = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.autochdir = false
vim.o.rnu = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
-- vim.o.list = true
-- vim.o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.winborder = "single"

require("configs.mappings")

-- Highlight Yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

require("lazy").setup({
  { import = "plugins" },
}, lazy_config)
