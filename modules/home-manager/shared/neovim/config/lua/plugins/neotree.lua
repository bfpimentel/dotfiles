return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = true,
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    window = {
      position = "right",
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
      },
      follow_current_file = {
        leave_dirs_open = true,
        enabled = true,
      },
    },
  },
  keys = {
  },
}
