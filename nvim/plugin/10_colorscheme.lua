_B.add({
  {
    src = "https://github.com/neanias/everforest-nvim",
    name = "everforest",
    data = {
      load = function()
        require("everforest").setup({
          -- background = "soft",
          transparent_background_level = 2,
          italics = false,
          float_style = "dim",
        })

        require("everforest").load()
      end,
    },
  },
  {
    src = "https://github.com/oskarnurm/koda.nvim",
    name = "koda",
    data = {
      load = function()
        require("koda").setup({
          transparent = true,
          auto = true,
          cache = true,
        })
      end,
    },
  },
})
