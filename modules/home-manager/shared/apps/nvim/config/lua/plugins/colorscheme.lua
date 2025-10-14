local P = require("utils.pack")

P.add({
  {
    src = "https://github.com/adibhanna/forest-night.nvim",
    name = "forest-night",
  },
  {
    src = "https://github.com/projekt0n/github-nvim-theme",
    name = "github",
    data = {
      init = function(_)
        require("github-theme").setup({
          options = {
            transparent = true,
          },
        })
      end,
    },
  },
  {
    src = "https://github.com/sainnhe/everforest",
    name = "everforest",
    data = {
      init = function(_)
        vim.g.everforest_enable_italic = true
        vim.g.everforest_better_performance = true
        vim.g.everforest_transparent_background = true
      end,
    },
  },
  {
    src = "https://github.com/rebelot/kanagawa.nvim",
    name = "kanagawa",
    data = {
      init = function(_)
        require("kanagawa").setup({
          transparent = false,
          theme = "wave",
        })
      end,
    },
  },
})

vim.cmd([[ colorscheme everforest ]])
