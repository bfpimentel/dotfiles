return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    priority = 1000,
    init = function()
      vim.cmd([[colorscheme catppuccin-macchiato]])
      vim.cmd.hi "Comment gui=none"
      vim.g.theme = "catppuccin"
    end,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      integrations = {
        which_key = true,
        blink_cmp = true,
        notify = true,
        neotree = true,
        telescope = {
          enable = true,
        },
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    enabled = false,
    priority = 1000,
    init = function()
      vim.cmd([[colorscheme tokyonight-moon]])
      vim.cmd.hi "Comment gui=none"
      vim.g.theme = "tokyonight-moon"
    end,
    opts = {
      -- transparent = true,
      -- styles = {
      --   sidebars = "transparent",
      --   floats = "transparent",
      -- },
    },
  },
  {
    "ntk148v/habamax.nvim",
    name = "habamax",
    enabled = false,
    dependencies = { "rktjmp/lush.nvim" },
    init = function()
      vim.cmd.colorscheme "habamax.nvim"
      vim.g.theme = "habamax"
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    enabled = false,
    priority = 1000,
    config = true,
    opts = {
      transparent_mode = true,
    },
    init = function()
      vim.opt.background = "dark"
      vim.cmd([[colorscheme gruvbox]])
      vim.g.theme = "gruvbox"
    end
  }
}
