local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

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

if os.getenv("SSH_TTY") == nil then
	vim.opt.clipboard = "unnamedplus"
else
	vim.opt.clipboard:append("unnamedplus")

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
end

vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=200 })
  augroup END
]])

require("lazy").setup({
	spec = {
		{ "LazyVim/LazyVim" },
		{ import = "bfpimentel/plugins" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	checker = { enabled = true, notify = false },
})

vim.cmd([[colorscheme tokyonight]])
