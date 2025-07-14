return {
  {
    "sainnhe/everforest",
    name = "everforest",
    lazy = false,
    priority = 10000,
    init = function()
      vim.g.everforest_enable_italic = true
      vim.g.everforest_better_performance = true
      vim.cmd([[ colorscheme everforest ]])
    end,
  },
}
