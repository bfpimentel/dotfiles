-- General
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Globals
vim.g.autoformat = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

-- Vim Config
vim.o.mouse = "a"
vim.o.mousescroll = "ver:25,hor:6"
vim.o.switchbuf = "usetab"
vim.o.undofile = true
vim.o.swapfile = false

-- Enable all filetype plugins and syntax
vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then vim.cmd("syntax enable") end

-- UI
vim.o.cmdheight = 0
vim.o.termguicolors = true
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
vim.o.colorcolumn = "+1"
vim.o.cursorline = true
vim.o.linebreak = true
vim.o.list = true
vim.o.number = true
vim.o.winborder = "single"
vim.o.pumborder = vim.o.winborder
vim.o.pumheight = 10
vim.o.ruler = false
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.rnu = true
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "tab:> ,trail:-,nbsp:+"

-- Editing
vim.o.conceallevel = 0
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = "rqnl1j"
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.infercase = true
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelloptions = "camel"
vim.o.tabstop = 2
vim.o.virtualedit = "block"
vim.o.iskeyword = "@,48-57,_,192-255,-"

-- Completion
vim.o.complete = ".,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,nosort"
vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
