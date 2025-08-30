local P = require("utils.pack")

P.add({
  { src = "https://github.com/tpope/vim-sleuth" },
  {
    src = "https://github.com/andrewferrier/wrapping.nvim",
    data = {
      lazy = {
        ft = {
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
      init = function(_)
        require("wrapping").setup({
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
        })
      end,
    },
  },
  {
    src = "https://github.com/OXY2DEV/markview.nvim",
    data = {
      lazy = { ft = { "markdown" } },
      init = function(_)
        require("markview").setup({
          preview = {
            filetypes = { "markdown" },
            ignore_buftypes = {},
          },
        })
      end,
    },
  },
  {
    src = "https://github.com/smjonas/inc-rename.nvim",
    data = {
      init = function(_) require("inc_rename").setup({}) end,
      keys = {
        { "rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
      },
    },
  },
  {
    src = "https://github.com/akinsho/toggleterm.nvim",
    data = {
      init = function(_) require("toggleterm").setup() end,
      keys = function()
        local Lazygit = require("toggleterm.terminal").Terminal:new({
          cmd = "lazygit",
          hidden = true,
          direction = "float",
          float_opts = {
            border = vim.opt.winborder,
            width = function() return math.floor(vim.o.columns * 0.8) end,
            height = 50,
          },
        })

        return {
          { "gg", function() Lazygit:toggle() end, opts = { desc = "Lazygit" } },
        }
      end,
    },
  },
})
