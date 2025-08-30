local P = require("utils.pack")

local function init_themes()
  vim.g.everforest_enable_italic = true
  vim.g.everforest_better_performance = true
  vim.g.everforest_transparent_background = true

  vim.cmd([[ colorscheme everforest ]])
end

P.add({
  {
    src = "https://github.com/adibhanna/forest-night.nvim",
    name = "forest-night",
  },
  {
    src = "https://github.com/sainnhe/everforest",
    name = "everforest",
    data = {
      init = function(_) init_themes() end,
    },
  },
})
