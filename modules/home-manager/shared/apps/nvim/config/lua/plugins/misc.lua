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
        { "<Leader>rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
      },
    },
  },
  {
    src = "https://github.com/kdheepak/lazygit.nvim",
    data = {
      init = function(_) end,
      lazy = {
        keys = { "<Leader>gg" },
      },
      keys = {
        { "<Leader>gg", ":LazyGit<CR>", opts = { desc = "LazyGit" } },
      },
    },
  },
  {
    src = "https://github.com/christoomey/vim-tmux-navigator",
    data = {
      init = function(_) end,
      keys = {
        -- Normal mode
        { mode = "n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Move Cursor to Left Window" } },
        { mode = "n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Move Cursor to Bottom Window" } },
        { mode = "n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Move Cursor to Top Window" } },
        { mode = "n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Move Cursor to Right Window" } },
        -- Terminal mode
        { mode = "t", "<C-h>", "<cmd><C-w>TmuxNavigateLeft<cr>", { desc = "Move Cursor to Left Window" } },
        { mode = "t", "<C-j>", "<cmd><C-w>TmuxNavigateDown<cr>", { desc = "Move Cursor to Bottom Window" } },
        { mode = "t", "<C-k>", "<cmd><C-w>TmuxNavigateUp<cr>", { desc = "Move Cursor to Top Window" } },
        { mode = "t", "<C-l>", "<cmd><C-w>TmuxNavigateRight<cr>", { desc = "Move Cursor to Right Window" } },
      },
    },
  },
})
