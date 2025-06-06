vim.g.theme = "gruvbox"
vim.g.theme_transparency = false

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
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
    },
    init = function()
      if vim.g.theme == "catppuccin" then
        vim.cmd([[colorscheme catppuccin-macchiato]])
        vim.cmd.hi("Comment gui=none")
      end
    end,
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    opts = {
      transparent = vim.g.theme_transparency,
      styles = {
        sidebars = vim.g.theme_transparency and "transparent",
        floats = vim.g.theme_transparency and "transparent",
      },
    },
    init = function()
      if vim.g.theme == "tokyonight" then
        vim.cmd([[colorscheme tokyonight-moon]])
        vim.cmd.hi("Comment gui=none")
      end
    end,
  },
  {
    "ntk148v/habamax.nvim",
    name = "habamax",
    dependencies = { "rktjmp/lush.nvim" },
    init = function()
      if vim.g.theme == "habamax" then vim.cmd.colorscheme("habamax.nvim") end
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    config = true,
    opts = {
      transparent_mode = vim.g.theme_transparency,
    },
    init = function()
      if vim.g.theme == "gruvbox" then
        vim.opt.background = "dark"
        vim.cmd([[colorscheme gruvbox]])
      end
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    config = true,
    opts = {
      transparent = vim.g.theme_transparency,
    },
    init = function()
      if vim.g.theme == "kanagawa" then
        vim.opt.background = "dark"
        vim.cmd([[colorscheme kanagawa]])
      end
    end,
  },
}
