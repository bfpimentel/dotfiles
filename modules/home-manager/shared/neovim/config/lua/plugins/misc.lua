local add, now = MiniDeps.add, MiniDeps.now

add({ source = "tpope/vim-sleuth" })
add({ source = "smjonas/inc-rename.nvim" })
add({ source = "akinsho/toggleterm.nvim" })
add({
  source = "andrewferrier/wrapping.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
})
add({
  source = "OXY2DEV/markview.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
})

now(function()
  require("markview").setup()
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
end)

now(function()
  require("inc_rename").setup({
    cmd_name = "IncRename",
  })

  vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "Rename Symbol" })
end)

now(function()
  local Terminal = require("toggleterm.terminal").Terminal
  local Lazygit = Terminal:new({
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

  vim.keymap.set("n", "<Leader>gg", toggle_lazygit, { desc = "Toggle LazyGit", noremap = true, silent = true })
end)
