local function init_themes()
  vim.g.everforest_enable_italic = true
  vim.g.everforest_better_performance = true
  vim.g.everforest_transparent_background = true

  vim.cmd([[ colorscheme everforest ]])
end

vim.pack.add({
  {
    src = "https://github.com/sainnhe/everforest",
    name = "everforest",
  },
  {
    src = "https://github.com/adibhanna/forest-night.nvim",
    name = "forest-night",
  },
})

init_themes()
