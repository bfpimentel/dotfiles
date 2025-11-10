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
  -- {
  --   src = "https://github.com/OXY2DEV/markview.nvim",
  --   data = {
  --     lazy = { ft = { "markdown" } },
  --     init = function(_)
  --       require("markview").setup({
  --         preview = {
  --           filetypes = { "markdown" },
  --           ignore_buftypes = {},
  --         },
  --       })
  --     end,
  --   },
  -- },
  {
    src = "https://github.com/smjonas/inc-rename.nvim",
    data = {
      init = function(_) require("inc_rename").setup({}) end,
      keys = function()
        return {
          { "<Leader>rn", ":IncRename ", opts = { desc = "Rename Symbol" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/kdheepak/lazygit.nvim",
    data = {
      init = function(_) end,
      lazy = {
        keys = { "<Leader>gg" },
      },
      keys = function()
        return {
          { "<Leader>gg", ":LazyGit<CR>", opts = { desc = "LazyGit" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/mrjones2014/smart-splits.nvim",
    data = {
      init = function(_) require("smart-splits").setup() end,
      keys = function()
        local SmartSplits = require("smart-splits")
        return {
          { mode = "n", "<C-h>", SmartSplits.move_cursor_left, { desc = "Move Cursor to Left Window" } },
          { mode = "n", "<C-j>", SmartSplits.move_cursor_right, { desc = "Move Cursor to Bottom Window" } },
          { mode = "n", "<C-k>", SmartSplits.move_cursor_up, { desc = "Move Cursor to Top Window" } },
          { mode = "n", "<C-l>", SmartSplits.move_cursor_right, { desc = "Move Cursor to Right Window" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    data = {
      init = function(_)
        require("tiny-inline-diagnostic").setup({
          preset = "classic",
          multilines = { enabled = true },
          add_messages = { display_count = true },
        })
      end,
    },
  },
})
