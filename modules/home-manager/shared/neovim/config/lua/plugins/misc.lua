return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    "jinh0/eyeliner.nvim",
    lazy = false,
    config = function()
      require("eyeliner").setup({
        highlight_on_key = true,
        dim = false,
      })
    end,
  },
  {
    "tpope/vim-sleuth",
    lazy = false,
  },
  {
    "andrewferrier/wrapping.nvim",
    lazy = false,
    opts = {
      auto_set_mode_filetype_allowlist = {
        "asciidoc",
        "gitcommit",
        "latex",
        "mail",
        "markdown",
        "rst",
        "tex",
        "text",
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    }
  }
}
