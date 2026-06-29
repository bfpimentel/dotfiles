Pack.later(function()
  Pack.add({ "https://github.com/smjonas/inc-rename.nvim" })

  require("inc_rename").setup({})

  Util.map_keys({
    { "<leader>rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
  })
end)

Pack.later(function()
  Pack.add({ "https://github.com/stevearc/quicker.nvim" })

  local Quicker = require("quicker")

  Quicker.setup()

  Util.map_keys({
    { "<leader>q", function() Quicker.toggle({ loclist = true }) end, opts = { desc = "Toggle Loclist" } },
  })
end)
