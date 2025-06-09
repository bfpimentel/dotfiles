local add, now = MiniDeps.add, MiniDeps.now

add({ source = "catppuccin/nvim", name = "catppuccin" })
add({ source = "folke/tokyonight.nvim", name = "tokyonight" })
add({ source = "ellisonleao/gruvbox.nvim", name = "habamax" })
add({ source = "webhooked/kanso.nvim", name = "kanso" })

now(function()
  vim.g.theme = "kanso"
  vim.g.theme_transparency = true
end)

now(function()
  require("catppuccin").setup({
    flavour = "mocha",
    transparent_background = vim.g.theme_transparency,
    term_colors = true,
    integrations = {
      which_key = true,
      blink_cmp = true,
      notify = true,
      neotree = true,
      telescope = { enable = true },
    },
  })

  require("tokyonight").setup({
    transparent = vim.g.theme_transparency,
    styles = {
      sidebars = vim.g.theme_transparency and "transparent",
      floats = vim.g.theme_transparency and "transparent",
    },
  })

  require("gruvbox").setup({
    transparent_mode = vim.g.theme_transparency,
  })

  require("kanso").setup({
    transparent = vim.g.theme_transparency,
    theme = "ink",
  })

  vim.opt.background = "dark"
  vim.cmd("colorscheme " .. vim.g.theme)
end)
