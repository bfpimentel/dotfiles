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
    default_component_configs = {
      indent = {
        indent_size = 1,
      },
    },
    window = {
      position = "right",
    },
    filesystem = {
      bind_to_cwd = true,
      filtered_items = {
        hide_dotfiles = false,
      },
      follow_current_file = {
        leave_dirs_open = true,
        enabled = true,
      },
    },
  },
}
