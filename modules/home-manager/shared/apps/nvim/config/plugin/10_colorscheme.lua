_B.add({
  {
    src = "https://github.com/adibhanna/forest-night.nvim",
    confirm = false,
    name = "forest-night",
  },
  {
    src = "https://github.com/projekt0n/github-nvim-theme",
    confirm = false,
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
    confirm = false,
    name = "everforest",
    data = {
      init = function(_)
        vim.g.everforest_enable_italic = false
        vim.g.everforest_better_performance = true
        vim.g.everforest_transparent_background = 2
        vim.g.everforest_float_style = "dim"
      end,
    },
  },
  {
    src = "https://github.com/rebelot/kanagawa.nvim",
    confirm = false,
    name = "kanagawa",
    data = {
      init = function(_)
        require("kanagawa").setup({
          transparent = true,
          theme = "wave",
          commentStyle = { italic = false },
          functionStyle = { italic = false },
          keywordStyle = { italic = false },
          statementStyle = { bold = true, italic = false },
        })
      end,
    },
  },
  {
    src = "https://github.com/thesimonho/kanagawa-paper.nvim",
    confirm = false,
    name = "kanagawa-paper",
    data = {
      init = function(_)
        require("kanagawa-paper").setup({
          transparent = true,
          cache = true,
        })
      end,
    },
  },
})

vim.cmd([[ colorscheme everforest ]])
