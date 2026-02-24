Pack.on_filetype("dart", function()
  Pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-flutter/flutter-tools.nvim",
  })

  require("flutter-tools").setup({
    ui = {
      border = "single",
    },
  })
end)
