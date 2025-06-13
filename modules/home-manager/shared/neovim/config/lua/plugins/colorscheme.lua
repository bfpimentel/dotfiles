local add, now = MiniDeps.add, MiniDeps.now

-- add({ source = "sainnhe/gruvbox-material", name = "gruvbox" })
add({ source = "rose-pine/neovim", name = "rose-pine" })

-- now(function()
--   vim.g.gruvbox_material_background = "soft"
--   vim.g.gruvbox_material_transparent_background = vim.g.theme_transparency and 1 or 0
--   vim.g.gruvbox_material_foreground = "material"
--   vim.g.gruvbox_material_ui_contrast = "high"
--   vim.g.gruvbox_material_float_style = "material"
--   vim.g.gruvbox_material_statusline_style = "material"
--   vim.g.gruvbox_material_cursor = "auto"
--
--   vim.cmd.colorscheme("gruvbox-material")
-- end)

now(function()
  local RosePine = require("rose-pine")
  RosePine.setup({
    variant = "moon",
    dark_variant = "moon",
  })

  vim.cmd("colorscheme rose-pine")
end)
