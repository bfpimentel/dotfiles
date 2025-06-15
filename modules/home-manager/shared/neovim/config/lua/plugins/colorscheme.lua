local add, now = MiniDeps.add, MiniDeps.now

add({ source = "rose-pine/neovim", name = "rose-pine" })

now(function()
  local RosePine = require("rose-pine")
  RosePine.setup({
    variant = "moon",
    dark_variant = "moon",
  })

  vim.cmd("colorscheme rose-pine")
end)
