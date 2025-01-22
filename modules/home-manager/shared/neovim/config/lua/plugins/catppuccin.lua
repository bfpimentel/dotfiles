return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = true,
  priority = 1000,
  init = function()
    vim.cmd.colorscheme "catppuccin-macchiato"
    vim.cmd.hi "Comment gui=none"
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
}
