return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    options = {
      theme = vim.g.theme,
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {
        {
          'lsp_status',
          icon = '',
          symbols = {
            spinner = { "◐", "◓", "◑", "◒" },
            done = '✓',
            separator = ' ',
          },
          ignore_lsp = {},
        }
      },
      lualine_x = {
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
          -- color = { bg = "#ff9e64" },
        }
      }
    },
  }
}
