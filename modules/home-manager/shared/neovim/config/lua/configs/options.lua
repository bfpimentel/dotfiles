require("nvchad.options")

-- Vim Config
vim.g.autoformat = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autochdir = true
vim.opt.rnu = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- Clipboard
local osc52 = require("vim.ui.clipboard.osc52")

vim.opt.clipboard = "unnamedplus"
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

-- Highlight Yank
vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=200 })
  augroup END
]])

