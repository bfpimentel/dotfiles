local add, now = MiniDeps.add, MiniDeps.now

add({ source = "sainnhe/everforest", name = "everforest" })

now(function()
  vim.g.everforest_enable_italic = true
  vim.g.everforest_better_performance = true
  vim.cmd([[ colorscheme everforest ]])
end)
