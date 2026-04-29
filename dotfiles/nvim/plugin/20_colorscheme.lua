Pack.now(function()
  Pack.add({
    {
      src = "https://github.com/sainnhe/everforest",
      name = "everforest",
    },
  })

  vim.g.everforest_enable_italic = 0
  vim.g.everforest_transparent_background = 2
  vim.g.everforest_float_style = "dim"

  vim.cmd("colorscheme everforest")
end)
