return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
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
    {
      "<leader>ns",
      ":Neotree toggle=true source=filesystem action=focus<CR>",
      mode = "n",
      desc = "[N]eotree [S]how",
    },
  },
}
