return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    options = {
      theme = "catppuccin",
      component_separators = { left = "|", right = "|" },
      section_separators = { left = "", right = "" },
    },
  },
}
