local add, now = MiniDeps.add, MiniDeps.now

add({ source = "sphamba/smear-cursor.nvim" })
add({ source = "tpope/vim-sleuth" })
add({ source = "smjonas/inc-rename.nvim" })
add({ source = "OXY2DEV/markview.nvim" })
add({ source = "folke/flash.nvim" })
add({
  source = "andrewferrier/wrapping.nvim",
  depends = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
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
  require("inc_rename").setup()

  vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "Rename Symbol" })
end)
