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
    confirm = false,
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
})
