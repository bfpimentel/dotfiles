local add, now = MiniDeps.add, MiniDeps.now

add({ source = "webhooked/kanso.nvim", name = "kanso" })
add({ source = "sainnhe/gruvbox-material", name = "gruvbox" })

now(function()
  vim.g.theme = "gruvbox_material"
  vim.g.theme_transparency = true

  require("kanso").setup({
    transparent = vim.g.theme_transparency,
    theme = "ink",
  })

  -- Gruvbox
  vim.g.gruvbox_material_background = "soft"
  vim.g.gruvbox_material_transparent_background = vim.g.theme_transparency and 1 or 0

  vim.opt.background = "dark"
  vim.cmd.colorscheme("gruvbox-material")
end)
