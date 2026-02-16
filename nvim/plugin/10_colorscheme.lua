_B.pack.now(function()
  _B.pack.add({
    {
      src = "https://github.com/neanias/everforest-nvim",
      name = "everforest",
    },
  })

  local Everforest = require("everforest")

  Everforest.setup({
    transparent_background_level = 2,
    italics = false,
    float_style = "dim",
  })

  Everforest.load()
end)
