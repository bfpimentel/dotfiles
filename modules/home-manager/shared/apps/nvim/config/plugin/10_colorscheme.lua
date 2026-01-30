_B.add({
  {
    src = "https://github.com/sainnhe/everforest",
    name = "everforest",
    data = {
      load = function()
        vim.g.everforest_enable_italic = false
        vim.g.everforest_better_performance = true
        vim.g.everforest_transparent_background = 2
        vim.g.everforest_float_style = "dim"
      end,
    },
  },
})

vim.cmd([[ colorscheme everforest ]])
