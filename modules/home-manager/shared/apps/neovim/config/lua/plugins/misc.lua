local K = require("utils.keys")

vim.pack.add({
  { src = "https://github.com/tpope/vim-sleuth" },
  { src = "https://github.com/smjonas/inc-rename.nvim" },
  { src = "https://github.com/andrewferrier/wrapping.nvim" },
  { src = "https://github.com/OXY2DEV/markview.nvim" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
})

require("inc_rename").setup({})

require("wrapping").setup({
  auto_set_mode_filetype_allowlist = {
    "asciidoc",
    "gitcommit",
    "latex",
    "mail",
    "markdown",
    "rst",
    "tex",
    "text",
  },
})

require("markview").setup({
  preview = {
    filetypes = { "markdown", "codecompanion" },
    ignore_buftypes = {},
  },
})

local Lazygit = require("toggleterm.terminal").Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",
  float_opts = {
    border = vim.opt.winborder,
    width = function() return math.floor(vim.o.columns * 0.8) end,
    height = 50,
  },
})

local function toggle_lazygit() Lazygit:toggle() end

K.map("rn", ":IncRename ", { desc = "Rename Symbol" })
K.map("gg", toggle_lazygit, { desc = "Toggle LazyGit", noremap = true, silent = true })
