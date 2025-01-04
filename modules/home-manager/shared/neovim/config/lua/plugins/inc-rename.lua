return {
  "smjonas/inc-rename.nvim",
  lazy = false,
  config = function()
    require("inc_rename").setup()

    vim.keymap.set("n", "<leader>rn", ":IncRename ", { desc = "[R]e[n]ame" })
  end,
}
