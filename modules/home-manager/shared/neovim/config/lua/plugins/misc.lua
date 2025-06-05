return {
  {
    "tpope/vim-sleuth",
    lazy = false,
  },
  {
    "smjonas/inc-rename.nvim",
    lazy = false,
    opts = {},
    keys = {
      {
        "<leader>rn",
        function()
          local soup = ""
          vim.cmd(":IncRename " .. vim.fn.expand("<cword>"))
        end,
        desc = "Rename Occurrences"
      },
    }
  },
  {
    "folke/lazydev.nvim",
    lazy = false,
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        { path = "LazyVim",            words = { "LazyVim" } },
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
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
