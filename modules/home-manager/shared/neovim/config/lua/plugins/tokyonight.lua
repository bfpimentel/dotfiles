return {
  "folke/tokyonight.nvim",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme "tokyonight-storm"
    vim.cmd.hi "Comment gui=none"
  end,
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl, c)
      local prompt = "#2d3149"
      hl.TelescopeNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeBorder = {
        bg = c.bg_dark,
        fg = prompt,
      }
      hl.TelescopePromptNormal = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopePromptBorder = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopePromptTitle = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopePreviewTitle = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
      hl.TelescopeResultsTitle = {
        bg = c.bg_dark,
        fg = c.fg_dark,
      }
    end,
  },
}
