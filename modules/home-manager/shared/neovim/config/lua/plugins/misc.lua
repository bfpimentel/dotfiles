local add, now = MiniDeps.add, MiniDeps.now

add({ source = "tpope/vim-sleuth" })
add({ source = "sphamba/smear-cursor.nvim" })
add({ source = "smjonas/inc-rename.nvim" })
add({ source = "folke/flash.nvim" })
add({ source = "akinsho/toggleterm.nvim" })
add({
  source = "andrewferrier/wrapping.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
})
add({
  source = "OXY2DEV/markview.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
  },
})

now(function()
  require("smear_cursor").setup()
  require("markview").setup()
  require("flash").setup({
    modes = {
      search = {
        enabled = true,
        highlight = { backdrop = true },
      },
    },
  })
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
  local ToggleTerm = require("toggleterm")
  ToggleTerm.setup({
    direction = "vertical",
    size = vim.o.columns * 0.3,
    open_mapping = [[<C-t>]],
    shell = "zsh",
  })

  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = vim.opt.winborder,
      width = function() return math.floor(vim.o.columns * 0.8) end,
      height = 50,
    },
  })
  local function toggle_lazygit() lazygit:toggle() end

  vim.keymap.set("n", "<Leader>gg", toggle_lazygit, { desc = "Toggle LazyGit", noremap = true, silent = true })
end)
