return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  lazy = false,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "ahmedkhalf/project.nvim" },
    {
      "nvim-tree/nvim-web-devicons",
      enabled = vim.g.have_nerd_font
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
  },
  config = function()
    local telescope = require("telescope")

    require("project_nvim").setup({
      detection_methods = { "pattern" },
      patterns = { ".git" },
    })

    telescope.setup({
      defaults = {
        path_display = { "filename_first" },
        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      }
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "projects")

    -- Telescope
    local builtin = require "telescope.builtin"
    local map = vim.keymap.set
    map("n", "<leader>fp", builtin.find_files, { desc = "[S]earch [F]iles" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    map("n", "<leader>ft", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    map("n", "<leader>fi", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    map("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    map("n", "<leader>fo", builtin.oldfiles, { desc = "[S]earch Recent Files" })
    map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
  end,
}
