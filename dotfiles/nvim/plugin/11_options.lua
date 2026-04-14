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

-- Clipboard
vim.o.clipboard = "unnamedplus"

if vim.env.SSH_TTY and not vim.env.TMUX then
  local function paste() return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") } end

  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

-- Diagnostics
local diagnostic_opts = {
  signs = { priority = 9999, severity = { min = "WARN", max = "ERROR" } },
  underline = { severity = { min = "HINT", max = "ERROR" } },
  virtual_lines = false,
  update_in_insert = false,
}

Pack.later(function()
  vim.diagnostic.config(diagnostic_opts)

  vim.lsp.enable({
    "eslint",
    "fish",
    "html",
    "json",
    "lua",
    "nix",
    "oxlint",
    "python",
    "qml",
    "typescript",
    "tailwindcss",
    "yaml",
  })

  vim.lsp.inline_completion.enable()
end)
