_B.add({
  {
    src = "https://github.com/smjonas/inc-rename.nvim",
    confirm = false,
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
    confirm = false,
    data = {
      lazy = {
        keys = { "<Leader>gg" },
      },
      init = function(_) end,
      keys = function()
        return {
          { "<Leader>gg", ":LazyGit<CR>", opts = { desc = "LazyGit" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/mrjones2014/smart-splits.nvim",
    confirm = false,
    data = {
      init = function(_) require("smart-splits").setup() end,
      keys = function()
        local SmartSplits = require("smart-splits")
        return {
          { mode = "n", "<C-h>", SmartSplits.move_cursor_left, opts = { desc = "Move Cursor to Left Window" } },
          { mode = "n", "<C-j>", SmartSplits.move_cursor_right, opts = { desc = "Move Cursor to Bottom Window" } },
          { mode = "n", "<C-k>", SmartSplits.move_cursor_up, opts = { desc = "Move Cursor to Top Window" } },
          { mode = "n", "<C-l>", SmartSplits.move_cursor_right, opts = { desc = "Move Cursor to Right Window" } },
        }
      end,
    },
  },
  {
    src = "https://github.com/sindrets/diffview.nvim",
    data = {
      lazy = {
        keys = { "<Leader>gh" },
      },
      init = function(_)
        require("diffview").setup({
          hooks = {
            view_opened = function()
              _B.map_keys({
                { "<Leader>gh", ":DiffviewClose<CR>", opts = { desc = "Close Diffview" } },
              })
            end,
            view_closed = function()
              _B.map_keys({
                { "<Leader>gh", ":DiffviewOpen<CR>", opts = { desc = "Open Diffview" } },
              })
            end,
          },
        })
      end,
      keys = {
        { "<Leader>gh", ":DiffviewOpen<CR>", opts = { desc = "Open Diffview" } },
      },
    },
  },
})
